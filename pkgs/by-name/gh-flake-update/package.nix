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
        # File for the minimal git commit message
        COMMIT_MESSAGE_FILE="$TMP_DIR/commit-message.txt"; readonly COMMIT_MESSAGE_FILE
        # File for the detailed pull request body
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

        # Generates the detailed report for the PR body.
        generate_pr_body() {
          local flake_update_output=$1
          local -n all_attrs_ref=$2
          local attr_reports=""

          for attr in "''${all_attrs_ref[@]}"; do
            local slug; slug=$(attr_to_slug "$attr")
            local current_build_path="$TMP_DIR/$slug.current"
            local next_build_path="$TMP_DIR/$slug.next"

            if [ ! -L "$current_build_path" ]; then
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>❌ Attribute: <code>''${attr}</code> (Initial Build Failed)</summary>

    						This attribute was already broken before the update and was skipped.
    						</details>
    					EOF
              )
            elif [ ! -L "$next_build_path" ]; then
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>🔴 Attribute: <code>''${attr}</code> (Update Build Failed)</summary>

    						The build for this attribute failed after the flake update.
    						</details>
    					EOF
              )
            else
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>✅ Attribute: <code>''${attr}</code> (Diff)</summary>

    						\`\`\`diff
    						$(nvd diff "$current_build_path" "$next_build_path" || echo "nvd diff command failed for $attr")
    						\`\`\`

    						</details>
    					EOF
              )
            fi
          done

          # Final PR body content
          cat <<-EOF
    				This PR was generated automatically to update the flake inputs.

    				<details>
    				<summary>Flake update summary (from commit message)</summary>

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
            # Redirect stderr to /dev/null as we don't want to show it.
            if ! nix build ".#''${attr}" --quiet --out-link "$TMP_DIR/$slug.current" 2> /dev/null; then
              echo "WARNING: Initial build failed for '$attr'. It will be skipped." >&2
            else
              successful_attrs+=("$attr")
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
              if ! nix build ".#''${attr}" --quiet --out-link "$TMP_DIR/$slug.next" 2> /dev/null; then
                echo "WARNING: Post-update build failed for '$attr'." >&2
              fi
            done
          fi

          echo "--- Generating content for commit and PR body ---"
          # Create the minimal commit message file.
          echo -e "$COMMIT_TITLE\n\n$flake_update_output" > "$COMMIT_MESSAGE_FILE"

          # Create the detailed PR body file.
          generate_pr_body "$flake_update_output" all_attrs > "$PR_BODY_FILE"

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
