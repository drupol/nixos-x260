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
        readonly GITHUB_ASSIGNEE="drupol"
        readonly GITHUB_REVIEWER="drupol"

        TMP_DIR=$(mktemp -d -t gh-flake-update.XXXXXXXXXX)
        readonly TMP_DIR
        WORKTREE_DIR="$TMP_DIR/worktree"
        readonly WORKTREE_DIR
        BRANCH_NAME="flake-update-$(date '+%F')"
        readonly BRANCH_NAME
        COMMIT_TITLE="chore(deps): update flake inputs"
        readonly COMMIT_TITLE
        COMMIT_MESSAGE_FILE="$TMP_DIR/commit-message.md"
        readonly COMMIT_MESSAGE_FILE

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

        generate_pr_body() {
          local flake_update_output=$1
          local -n all_hosts_ref=$2
          local host_reports=""

          for host in "''${all_hosts_ref[@]}"; do
            local current_build_path="$TMP_DIR/$host.current"
            local current_error_log="$TMP_DIR/$host.current.error"
            local next_build_path="$TMP_DIR/$host.next"
            local next_error_log="$TMP_DIR/$host.next.error"

            if [ ! -L "$current_build_path" ]; then
              # Case 1: Initial build failed. This host was skipped for the update.
              local error_content="Error log not found."
              if [ -s "$current_error_log" ]; then
                error_content=$(cat "$current_error_log")
              fi
              host_reports+=$(cat <<-EOF
    						<details>
    						<summary>❌ Host: <code>''${host}</code> (Initial Build Failed)</summary>

    						**The initial build for this host failed. It was not included in the update.**

    						<pre><code>''${error_content}</code></pre>
    						</details>
    					EOF
              )
            elif [ ! -L "$next_build_path" ]; then
              # Case 2: Initial build succeeded, but post-update build failed.
              local error_content="Error log not found."
              if [ -s "$next_error_log" ]; then
                error_content=$(cat "$next_error_log")
              fi
              host_reports+=$(cat <<-EOF
    						<details>
    						<summary>🔴 Host: <code>''${host}</code> (Update Build Failed)</summary>

    						**The build for this host failed after the flake update.**

    						<pre><code>''${error_content}</code></pre>
    						</details>
    					EOF
              )
            else
              # Case 3: Both builds succeeded. Generate the diff.
              host_reports+=$(cat <<-EOF
    						<details>
    						<summary>✅ Host: <code>''${host}</code> (Update Succeeded)</summary>

    						\`\`\`console
    						$(nvd diff "$current_build_path" "$next_build_path" || echo "nvd diff command failed for $host")
    						\`\`\`
    						</details>
    					EOF
              )
            fi
          done

          cat <<-EOF
    				''${COMMIT_TITLE}

    				This PR was generated automatically to update the flake inputs.

    				<details>
    				<summary>Flake update summary</summary>

    				\`\`\`console
    				''${flake_update_output}
    				\`\`\`
    				</details>

    				''${host_reports}
    			EOF
        }

        # --- Main Execution ---
        main() {
          echo "--- Starting flake update process ---"
          readarray -t all_hosts < <(nix eval .#nixosConfigurations --apply builtins.attrNames --json | jq -r '.[]')
          if [ ''${#all_hosts[@]} -eq 0 ]; then
            echo "Error: No NixOS hosts found. Exiting." >&2; exit 1
          fi
          echo "Found hosts: ''${all_hosts[*]}"

          echo "Creating git worktree at '$WORKTREE_DIR'..."
          git worktree add -B "$BRANCH_NAME" "$WORKTREE_DIR"
          cd "$WORKTREE_DIR"
          echo "Now operating in '$PWD'."

          # --- First Loop: Build "current" state ---
          echo "--- Building 'current' configurations (pre-update) ---"
          declare -a successful_hosts=()
          for host in "''${all_hosts[@]}"; do
            echo "Building current configuration for host: $host"
            if ! nix build ".#nixosConfigurations.\"''${host}\".config.system.build.toplevel" --out-link "$TMP_DIR/$host.current" 2> "$TMP_DIR/$host.current.error"; then
              echo "WARNING: Initial build failed for host '$host'. It will be skipped. Error logged." >&2
            else
              successful_hosts+=("$host")
              rm -f "$TMP_DIR/$host.current.error"
            fi
          done

          if [ ''${#successful_hosts[@]} -eq 0 ]; then
            echo "All initial host builds failed. Nothing to update. See logs above."
          fi

          echo "--- Updating flake.lock ---"
          local flake_update_output
          flake_update_output=$(nix flake update 2>&1)
          echo "$flake_update_output"

          if git diff --quiet flake.lock; then
            echo "No changes to flake.lock. Nothing to do."
            exit 0
          fi

          # --- Second Loop: Build "next" state for successful hosts only ---
          if [ ''${#successful_hosts[@]} -gt 0 ]; then
            echo "--- Building 'next' configurations (post-update) ---"
            for host in "''${successful_hosts[@]}"; do
              echo "Building next configuration for host: $host"
              if ! nix build ".#nixosConfigurations.\"''${host}\".config.system.build.toplevel" --out-link "$TMP_DIR/$host.next" 2> "$TMP_DIR/$host.next.error"; then
                echo "WARNING: Post-update build failed for host '$host'. Error logged." >&2
              else
                rm -f "$TMP_DIR/$host.next.error"
              fi
            done
          else
            echo "Skipping post-update builds as no hosts built successfully."
          fi

          echo "--- Generating PR body ---"
          generate_pr_body "$flake_update_output" all_hosts > "$COMMIT_MESSAGE_FILE"

          echo "--- Committing and Pushing ---"
          git add flake.lock
          git commit --file="$COMMIT_MESSAGE_FILE"
          git push --force origin "$BRANCH_NAME"

          echo "--- Creating GitHub PR ---"
          gh pr create \
            --file="$COMMIT_MESSAGE_FILE" \
            --head="$BRANCH_NAME" \
            --assignee="$GITHUB_ASSIGNEE" \
            --reviewer="$GITHUB_REVIEWER"

          echo "--- Successfully created PR for flake update! ---"
        }

        main "$@"
  '';
}
