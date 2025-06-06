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
          git worktree remove "$worktree_dir" --force || true
        rm -rf "$worktree_dir"
      fi
    }
    trap cleanup EXIT

    branch="flake-update-$(date '+%F')"
    tmpdir=$(dirname "$(mktemp tmp.XXXXXXXXXX -ut)")
    worktree_dir=$(mktemp -d "$tmpdir/worktree.XXXXXXXXXX")

    existing_worktree=$(git worktree list | grep "master" | awk '{print $1}' || true)
    if [ -n "$existing_worktree" ]; then
      echo "Worktree for 'master' already exists at $existing_worktree. Removing it..."
      git worktree remove "$existing_worktree" --force || true
    fi

    echo "Creating a temporary worktree at $worktree_dir ..."
    git worktree add --force "$worktree_dir" master
    cd "$worktree_dir"

    hosts=$(nix eval --json .#nixosConfigurations --apply builtins.attrNames | jq -r '.[]')

    results=""

    for host in $hosts; do
      echo "Processing host before flake.lock update: $host"

      # Build the current configuration, capture errors
      if ! nix build .#nixosConfigurations."''${host}".config.system.build.toplevel -o "''${host}".current 2>error.log; then
        error_message=$(<error.log)
        echo "Failed to build configuration for host: $host. Skipping..."
        results="''${results}\nHost: ''${host}\nBuild failed:\n$error_message\n"
        continue
      fi
    done

    # Update the flake.lock file
    nix flake update

    for host in $hosts; do
      echo "Processing host after flake.lock update: $host"

      # Build the next configuration, capture errors
      if ! nix build .#nixosConfigurations."''${host}".config.system.build.toplevel -o "''${host}".next 2>error.log; then
        error_message=$(<error.log)
        echo "Failed to build configuration for host: $host. Skipping..."
        results="''${results}\nHost: ''${host}\nBuild failed:\n$error_message\n"
        continue
      fi
    done

    for host in $hosts; do
      echo "Generating the closure diff for: $host ..."

      # Compare the builds, capture errors
      if ! diff_result=$(nvd diff ./"''${host}".current ./"''${host}".next 2>error.log); then
        error_message=$(<error.log)
        echo "Failed to compare builds for host: $host. Skipping..."
        results="''${results}\nHost: ''${host}\nDiff failed:\n$error_message\n"
        continue
      fi
      results="''${results}\nHost: ''${host}\n''${diff_result}\n"
    done

    echo -e "$results" > /tmp/flake-update-results.txt

    git checkout -b "$branch"
    title="chore: update flake inputs ($(date))"

    (
      echo "$title"
      echo -ne "\n\n\n\n"

      echo '```shell'
      echo -e "$results"
      echo '```'

      echo -ne "\n\n\n\n"
    ) | tee /tmp/commit-message.md

    changes="$(git status -s | grep -o 'M ' | wc -l)"

    if test "$changes" -eq 0; then
      echo "No changes"
      exit 0
    fi

    git status -s | grep 'M ' | cut -d 'M' -f 2 | xargs git add
    git commit -F /tmp/commit-message.md --no-signoff --no-verify --trailer "request-checks:true" --no-edit --cleanup=verbatim
    git push origin "$branch:$branch" --force

    gh pr create --base master --reviewer drupol --assignee drupol --body-file /tmp/commit-message.md --title "$title" --head "$branch" | tee /tmp/pr-url
  '';
}
