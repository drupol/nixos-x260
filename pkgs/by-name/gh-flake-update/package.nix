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
        #!/usr/bin/env bash
        set -euo pipefail

        # --- Configuration ---
        readonly GITHUB_ASSIGNEE="drupol"
        readonly GITHUB_REVIEWER="drupol"

        # --- Global Variables ---
        TMP_DIR=$(mktemp -d -t gh-flake-update.XXXXXXXXXX); readonly TMP_DIR
        WORKTREE_DIR="$TMP_DIR/worktree"; readonly WORKTREE_DIR
        BRANCH_NAME="flake-update-$(date '+%F')"; readonly BRANCH_NAME
        COMMIT_TITLE="chore(deps): update flake inputs"; readonly COMMIT_TITLE
        COMMIT_MESSAGE_FILE="$TMP_DIR/commit-message.md"; readonly COMMIT_MESSAGE_FILE

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

        # Creates a filesystem-safe "slug" from a flake attribute path.
        # e.g., "nixosConfigurations.x13.config" -> "nixosConfigurations-x13-config"
        attr_to_slug() {
          echo "$1" | tr '.' '-'
        }

        generate_pr_body() {
          local flake_update_output=$1
          local -n all_attrs_ref=$2
          local attr_reports=""

          for attr in "''${all_attrs_ref[@]}"; do
            local slug
            slug=$(attr_to_slug "$attr")
            local current_build_path="$TMP_DIR/$slug.current"
            local current_error_log="$TMP_DIR/$slug.current.error"
            local next_build_path="$TMP_DIR/$slug.next"
            local next_error_log="$TMP_DIR/$slug.next.error"

            if [ ! -L "$current_build_path" ]; then
              local error_content="Error log not found."
              if [ -s "$current_error_log" ]; then error_content=$(cat "$current_error_log"); fi
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>❌ Attribute: <code>''${attr}</code> (Initial Build Failed)</summary>

    						**The initial build for this attribute failed. It was not included in the update.**

    						<pre><code>''${error_content}</code></pre>
    						</details>
    					EOF
              )
            elif [ ! -L "$next_build_path" ]; then
              local error_content="Error log not found."
              if [ -s "$next_error_log" ]; then error_content=$(cat "$next_error_log"); fi
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>🔴 Attribute: <code>''${attr}</code> (Update Build Failed)</summary>

    						**The build for this attribute failed after the flake update.**

    						<pre><code>''${error_content}</code></pre>
    						</details>
    					EOF
              )
            else
              attr_reports+=$(cat <<-EOF
    						<details>
    						<summary>✅ Attribute: <code>''${attr}</code> (Update Succeeded)</summary>

    						\`\`\`diff
    						$(nvd diff "$current_build_path" "$next_build_path" || echo "nvd diff command failed for $attr")
    						\`\`\`
    						</details>
    					EOF
              )
            fi
          done

          cat <<-EOF
    				''${COMMIT_TITLE}

    				This PR was generated automatically to update the flake inputs for the following attributes:
    				''${all_attrs_ref[@]}

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
            echo "Example: $0 nixosConfigurations.my-host.config.system.build.toplevel homeConfigurations.my-user.activationPackage" >&2
            exit 1
          fi

          # Store all command-line arguments in an array for safe handling.
          declare -a all_attrs=("$@")
          echo "--- Starting flake update process for attributes: ''${all_attrs[*]} ---"

          git worktree add -B "$BRANCH_NAME" "$WORKTREE_DIR"
          cd "$WORKTREE_DIR"

          echo "--- Building 'current' configurations (pre-update) ---"
          declare -a successful_attrs=()
          for attr in "''${all_attrs[@]}"; do
            echo "Building current state for attribute: $attr"
            local slug; slug=$(attr_to_slug "$attr")
            if ! nix build ".#''${attr}" --out-link "$TMP_DIR/$slug.current" 2> "$TMP_DIR/$slug.current.error"; then
              echo "WARNING: Initial build failed for '$attr'. It will be skipped. Error logged." >&2
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
          else
            echo "Skipping post-update builds as no attributes built successfully."
          fi

          echo "--- Generating commit message file ---"
          generate_pr_body "$flake_update_output" all_attrs > "$COMMIT_MESSAGE_FILE"

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
            --reviewer $GITHUB_REVIEWER \
            --assignee $GITHUB_ASSIGNEE \
            --body-file "$COMMIT_MESSAGE_FILE" \
            --title "$COMMIT_TITLE" \
            --head "$BRANCH_NAME" \

          echo "--- Successfully created PR for flake update! ---"
        }

        main "$@"
  '';
}
