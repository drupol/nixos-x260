{
  writeShellApplication,
  gh,
  gitMinimal,
  nvd,
  jq,
  ...
}:
writeShellApplication {
  name = "gh-flake-update";
  runtimeInputs = [
    gh
    gitMinimal
    nvd
    jq
  ];
  text = ''
        # --- Configuration ---
        readonly GITHUB_ASSIGNEE="drupol"
        readonly GITHUB_REVIEWER="drupol"

        # --- Global Variables ---
        TMP_DIR=$(mktemp -d -t gh-flake-update.XXXXXXXXXX); readonly TMP_DIR
        WORKTREE_DIR="$TMP_DIR/worktree"; readonly WORKTREE_DIR
        BRANCH_NAME="flake-update-$(date '+%F')"; readonly BRANCH_NAME
        COMMIT_TITLE="chore(deps): update flake inputs"; readonly COMMIT_TITLE
        COMMIT_MESSAGE_FILE="$TMP_DIR/commit-message.md"; readonly COMMIT_MESSAGE_FILE
        PR_BODY_FILE="$TMP_DIR/pr-body.md"; readonly PR_BODY_FILE

        cleanup() {
          echo "--- Cleaning up ---"
          cd - >/dev/null 2>&1 || true
          if git worktree list | grep -q "$WORKTREE_DIR"; then
            echo "Removing git worktree at '$WORKTREE_DIR'..."
            git worktree remove --force "$WORKTREE_DIR"
          fi
          if [ -d "$TMP_DIR" ]; then
            echo "Removing temporary directory '$TMP_DIR'..."
            rm -rf "$TMP_DIR"
          fi
          echo "Cleanup complete."
        }
        trap cleanup EXIT INT TERM

        # --- Functions ---
        attr_to_slug() { echo "$1" | tr '.' '-'; }

        # Generates content for the commit message or PR body based on the mode.
        # Usage: generate_content <mode> <flake_output> <attrs_array_name>
        generate_content() {
          local mode=$1
          local flake_update_output=$2
          local -n all_attrs_ref=$3
          local attr_reports=""

          for attr in "''${all_attrs_ref[@]}"; do
            local slug; slug=$(attr_to_slug "$attr")
            local current_build_path="$TMP_DIR/$slug.current"
            local current_error_log="$TMP_DIR/$slug.current.error"
            local next_build_path="$TMP_DIR/$slug.next"
            local next_error_log="$TMP_DIR/$slug.next.error"

            if [ ! -L "$current_build_path" ]; then
              local error_content="Error log not found."
              if [ -f "$current_error_log" ]; then
                error_content=$(cat "$current_error_log")
                if [[ "$mode" == "summary" && $(wc -c < "$current_error_log") -gt 1024 ]]; then
                  error_content="$(head -n 20 "$current_error_log")\n\n... (log truncated in PR body, see full commit message for details)"
                fi
              fi
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>❌ Attribute: <code>''${attr}</code> (Initial Build Failed)</summary>
    						<pre><code>''${error_content}</code></pre>
    						</details>
    					EOF
              )
            elif [ ! -L "$next_build_path" ]; then
              local error_content="Error log not found."
              if [ -f "$next_error_log" ]; then
                error_content=$(cat "$next_error_log")
                if [[ "$mode" == "summary" && $(wc -c < "$next_error_log") -gt 1024 ]]; then
                  error_content="$(head -n 20 "$next_error_log")\n\n... (log truncated in PR body, see full commit message for details)"
                fi
              fi
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>🔴 Attribute: <code>''${attr}</code> (Update Build Failed)</summary>
    						<pre><code>''${error_content}</code></pre>
    						</details>
    					EOF
              )
            else
              local diff_content
              if [[ "$mode" == "summary" ]]; then
                diff_content="Diff is available in the full commit message."
              else
                diff_content=$(nvd diff "$current_build_path" "$next_build_path" || echo "nvd diff command failed for $attr")
              fi
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>✅ Attribute: <code>''${attr}</code> (Update Succeeded)</summary>

    						\`\`\`diff
    						''${diff_content}
    						\`\`\`

    						</details>
    					EOF
              )
            fi
          done

          local intro_message
          if [[ "$mode" == "summary" ]]; then
            intro_message="**Note: Logs and diffs may be truncated. See the full git commit message for unabridged details.**"
          else
            intro_message="This is the full automated update report."
          fi

          cat <<-EOF
    				This PR was generated automatically to update the flake inputs.

    				''${intro_message}

    				<details>
    				<summary>Flake update summary</summary>

    				\`\`\`console
    				''${flake_update_output}
    				\`\`\`

    				</details>

    				''${attr_reports}
    			EOF
        }

        # --- Main Execution ---
        main() {
          if [ "$#" -eq 0 ]; then
            echo "Usage: $0 <flake_attribute_1> [flake_attribute_2] ..." >&2
            exit 1
          fi
          declare -a all_attrs=("$@")
          echo "--- Starting update process for attributes: ''${all_attrs[*]} ---"

          git worktree add -B "$BRANCH_NAME" "$WORKTREE_DIR"
          cd "$WORKTREE_DIR"

          declare -a successful_attrs=()
          echo "--- Building 'current' configurations (pre-update) ---"
          for attr in "''${all_attrs[@]}"; do
            echo "Building current state for attribute: $attr"
            local slug; slug=$(attr_to_slug "$attr")
            if ! nix build ".#''${attr}" --out-link "$TMP_DIR/$slug.current" 2> "$TMP_DIR/$slug.current.error"; then
              echo "WARNING: Initial build failed for '$attr'. Error logged." >&2
            else
              successful_attrs+=("$attr"); rm -f "$TMP_DIR/$slug.current.error"
            fi
          done

          echo "--- Updating flake.lock ---"
          local flake_update_output; flake_update_output=$(nix flake update 2>&1)
          echo "$flake_update_output"

          if git diff --quiet flake.lock; then
            echo "No changes to flake.lock. Nothing to do."
            exit 0
          fi

          if [ ''${#successful_attrs[@]} -gt 0 ]; then
            echo "--- Building 'next' configurations (post-update) ---"
            for attr in "''${successful_attrs[@]}"; do
              echo "Building next state for attribute: $attr"
              local slug; slug=$(attr_to_slug "$attr")
              if ! nix build ".#''${attr}" --out-link "$TMP_DIR/$slug.next" 2> "$TMP_DIR/$slug.next.error"; then
                echo "WARNING: Post-update build failed for '$attr'. Error logged." >&2
              else
                rm -f "$TMP_DIR/$slug.next.error"
              fi
            done
          fi

          echo "--- Generating full content for git commit ---"
          local full_body; full_body=$(generate_content "full" "$flake_update_output" all_attrs)
          # Git commit file format is: Title\n\nBody
          echo -e "$COMMIT_TITLE\n\n$full_body" > "$COMMIT_MESSAGE_FILE"

          echo "--- Generating summarized content for PR body ---"
          # The PR body file does not need the title.
          generate_content "summary" "$flake_update_output" all_attrs > "$PR_BODY_FILE"

          echo "--- Committing and Pushing ---"
          git add flake.lock
          git commit \
          -F "$COMMIT_MESSAGE_FILE" \
          --no-signoff \
          --no-verify \
          --no-edit \
          --cleanup=verbatim

          git push --force origin "$BRANCH_NAME"

          echo "--- Creating GitHub PR ---"
          gh pr create \
            --title "$COMMIT_TITLE" \
            --body-file "$PR_BODY_FILE" \
            --head "$BRANCH_NAME" \
            --assignee "$GITHUB_ASSIGNEE" \
            --reviewer "$GITHUB_REVIEWER"

          echo "--- Successfully created PR for flake update! ---"
        }

        main "$@"
  '';
}
