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
    set -x

    cleanup() {
      echo "Cleaning up..."
      if [ -d "$worktree_dir" ]; then
        git worktree remove "$worktree_dir" --force || true
        rm -rf "$worktree_dir"
      fi
      [ -f "$commit_message_file" ] && rm -rf "$commit_message_file" || true
      [ -f "$pr_url_file" ] && rm -rf "$pr_url_file"
      rm -rf "*.current" "*.next"
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

    results=""

    build_configuration() {
      local host=$1
      local output=$2
      if ! nix build .#nixosConfigurations."''${host}".config.system.build.toplevel -o "''${output}" 2>error.log; then
        error_message=$(<error.log)
        echo "Failed to build configuration for host: $host. Skipping..."
        results="''${results}\nHost: ''${host}\nBuild failed:\n$error_message\n"
        return 1
      fi
      return 0
    }

    compare_builds() {
      local host=$1
      if ! diff_result=$(nvd diff ./"''${host}".current ./"''${host}".next 2>error.log); then
        error_message=$(<error.log)
        echo "Failed to compare builds for host: $host. Skipping..."
        results="''${results}\nHost: ''${host}\nDiff failed:\n$error_message\n"
        return 1
      fi
      results="''${results}\nHost: ''${host}\n''${diff_result}\n"
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

    echo -e "$results" > /tmp/flake-update-results.txt

    git checkout -b "$branch"
    title="chore: update flake inputs ($(date))"

    (
      echo "$title"
      echo -ne "\n\n\n\n"

      echo '```console'
      echo -e "$flake_update_output"
      echo '```'

      echo '```console'
      echo -e "$results"
      echo '```'

      echo -ne "\n\n\n\n"
    ) | tee "$commit_message_file"

    changes="$(git status -s | grep -o 'M ' | wc -l)"

    if test "$changes" -eq 0; then
      echo "No changes"
      exit 0
    fi

    git add .
    git commit\
    -F "$commit_message_file"\
    --no-signoff\
    --no-verify\
    --no-edit\
    --cleanup=verbatim
    git push origin "$branch:$branch" --force

    gh pr create \
      --reviewer drupol\
      --assignee drupol\
      --body-file "$commit_message_file"\
      --title "$title"\
      --head "$branch"\
      | tee "$pr_url_file"
  '';
}
