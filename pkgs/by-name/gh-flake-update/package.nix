{
  writeShellApplication,
  gh,
  gitMinimal,
  nvd,
  ...
}:
writeShellApplication {
  name = "gh-flake-update";
  runtimeInputs = [
    gh
    gitMinimal
    nvd
  ];
  text = ''
    cleanup() {
      echo "Cleaning up..."
      if [ -d "$worktree_dir" ]; then
        echo "Removing worktree directory: $worktree_dir"
        git worktree remove "$worktree_dir" --force || echo "Failed to remove worktree"
        rm -rf "$worktree_dir" || echo "Failed to remove directory: $worktree_dir"
      fi
      if [ -f "$commit_message_file" ]; then
        echo "Removing commit message file: $commit_message_file"
        rm -rf "$commit_message_file" || echo "Failed to remove commit message file"
      fi
      if [ -f "$pr_url_file" ]; then
        echo "Removing PR URL file: $pr_url_file"
        rm -rf "$pr_url_file" || echo "Failed to remove PR URL file"
      fi
      echo "Removing temporary build files (*.current, *.next)"
      rm -rf "*.current" "*.next" || echo "Failed to remove temporary build files"
    }
    trap cleanup EXIT

    branch="flake-update-$(date '+%F')"
    tmpdir=$(dirname "$(mktemp tmp.XXXXXXXXXX -ut)")
    worktree_dir=$(mktemp -d "$tmpdir/worktree.XXXXXXXXXX")
    commit_message_file=$(mktemp "$tmpdir/commit-message.XXXXXXXXXX.md")
    pr_url_file=$(mktemp "$tmpdir/pr-url.XXXXXXXXXX")

    existing_worktree=$(git worktree list | grep "master" | awk '{print $1}' || true)
    if [ -n "$existing_worktree" ]; then
      echo "Worktree for 'master' already exists at $existing_worktree. Removing it..."
      git worktree remove "$existing_worktree" --force || true
    fi

    echo "Creating a temporary worktree at $worktree_dir ..."
    git worktree add --force "$worktree_dir"
    cd "$worktree_dir"

    hosts=$(nix eval --json .#nixosConfigurations --apply builtins.attrNames | jq -r '.[]')

    result_lines=()

    build_configuration() {
      local host=$1
      local output=$2

      # Wrap the result in a <details>

      if ! nix build .#nixosConfigurations."''${host}".config.system.build.toplevel --quiet -o "''${output}" 2>error.log; then
        error_message=$(<error.log)
        echo "Failed to build configuration for host: $host. Skipping..."
        return 1
      fi
      return 0
    }

    compare_builds() {
      local host=$1

      result_lines+=("<details><summary>Host diff: ''${host}</summary>")

      if ! diff_result=$(nvd diff ./"''${host}".current ./"''${host}".next 2>error.log); then
        error_message=$(<error.log)
        result_lines+=("Host: ''${host}")
        result_lines+=('```console')
        result_lines+=("''${error_message}")
        result_lines+=('```')
        result_lines+=('</details>')
        return 1
      fi

      result_lines+=("Host: ''${host}")
      result_lines+=('```console')
      result_lines+=("''${diff_result}")
      result_lines+=('```')
      result_lines+=('</details>')
      return 0
    }

    for host in $hosts; do
      echo "Processing host before flake.lock update: $host"
      build_configuration "$host" "''${host}.current" || continue
    done

    echo "Updating flake.lock file..."
    flake_update_output=$(nix flake update 2>&1)

    for host in $hosts; do
      echo "Processing host after flake.lock update: $host"
      build_configuration "$host" "''${host}.next" || continue
    done

    for host in $hosts; do
      echo "Generating the closure diff for: $host ..."
      compare_builds "$host" || continue
    done

    rm -rf "*.current" "*.next" || true

    git checkout -b "$branch"
    title="chore: update flake inputs ($(date))"

    (
      printf "%s\n\n\n\n" "$title"
      printf "<details><summary>Flake update summary</summary>\n"
      # shellcheck disable=SC2059,SC2006,SC1012
      printf "```console\n%s\n```\n" "$flake_update_output"
      printf "</details>\n"

      for line in "''${result_lines[@]}"; do
        printf "%s\n" "$line"
      done

      printf "\n\n\n\n"
    ) | tee "$commit_message_file"

    changes="$(git status -s | grep -o 'M ' | wc -l)"

    if test "$changes" -eq 0; then
      echo "No changes"
      exit 0
    fi

    git add .
    git commit \
    -F "$commit_message_file" \
    --no-signoff \
    --no-verify \
    --no-edit \
    --cleanup=verbatim
    git push origin "$branch:$branch" --force

    gh pr create \
      --reviewer drupol \
      --assignee drupol \
      --body-file "$commit_message_file" \
      --title "$title" \
      --head "$branch" \
      | tee "$pr_url_file"
  '';
}
