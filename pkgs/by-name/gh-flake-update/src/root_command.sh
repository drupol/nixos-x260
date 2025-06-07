# shellcheck shell=bash
GITHUB_REVIEWER=${args[--reviewer]}
readonly GITHUB_REVIEWER
GITHUB_ASSIGNEE=${args[--assignee]}
readonly GITHUB_ASSIGNEE
all_attrs=()
eval "all_attrs=(${args[attributes]})"

# --- Runtime Setup ---
# This section now runs ONLY when main is called, after arg validation.
TMP_DIR=$(mktemp -d -t gh-flake-update.XXXXXXXXXX)
readonly TMP_DIR
WORKTREE_DIR="$TMP_DIR/worktree"
readonly WORKTREE_DIR
COMMIT_MESSAGE_FILE="$TMP_DIR/commit-message.txt"
readonly COMMIT_MESSAGE_FILE
PR_BODY_FILE="$TMP_DIR/pr-body.md"
readonly PR_BODY_FILE
BRANCH_NAME="flake-update-$(date '+%F')"
readonly BRANCH_NAME
COMMIT_TITLE="chore(deps): update flake inputs"
readonly COMMIT_TITLE
trap cleanup EXIT INT TERM

echo "--- Starting update process for attributes: ${all_attrs[*]} ---"

git worktree add -B "$BRANCH_NAME" "$WORKTREE_DIR"
cd "$WORKTREE_DIR" || {
  echo "Error: Failed to change directory to worktree '$WORKTREE_DIR'." >&2
  exit 1
}

declare -a successful_attrs=()
echo "--- Building 'current' configurations (pre-update) ---"
for attr in "${all_attrs[@]}"; do
  echo "Building current state for attribute: $attr"
  local slug
  slug=$(attr_to_slug "$attr")
  if ! nix build ".#${attr}" --quiet --out-link "$TMP_DIR/$slug.current" 2>/dev/null; then
    echo "WARNING: Initial build failed for '$attr'. It will be skipped." >&2
  else
    successful_attrs+=("$attr")
  fi
done

echo "--- Updating flake.lock ---"
local flake_update_output
flake_update_output=$(nix flake update 2>&1)
echo "$flake_update_output"

if git diff --quiet flake.lock; then
  echo "No changes to flake.lock. Nothing to do."
  # The trap will still call cleanup, which is correct here.
  exit 0
fi

if [ ${#successful_attrs[@]} -gt 0 ]; then
  echo "--- Building 'next' configurations (post-update) ---"
  # ... (rest of logic is unchanged) ...
  for attr in "${successful_attrs[@]}"; do
    echo "Building next state for attribute: $attr"
    local slug
    slug=$(attr_to_slug "$attr")
    if ! nix build ".#${attr}" --quiet --out-link "$TMP_DIR/$slug.next" 2>/dev/null; then
      echo "WARNING: Post-update build failed for '$attr'." >&2
    fi
  done
fi

echo "--- Generating content for commit and PR body ---"
echo -e "$COMMIT_TITLE\n\n$flake_update_output" >"$COMMIT_MESSAGE_FILE"
generate_pr_body "$flake_update_output" all_attrs >"$PR_BODY_FILE"

echo "--- Committing and Pushing ---"
git add flake.lock
git commit \
  -F "$COMMIT_MESSAGE_FILE" \
  --no-signoff \
  --no-verify \
  --no-edit \
  --cleanup=verbatim

git push --force origin "$BRANCH_NAME"

if [ -n "$GH_TOKEN" ] || [ -n "$GITHUB_TOKEN" ]; then
  echo "--- Creating GitHub PR ---"
  declare -a pr_opts=()
  if [ -n "$GITHUB_ASSIGNEE" ]; then
    pr_opts+=(--assignee "$GITHUB_ASSIGNEE")
    echo "Assignee: $GITHUB_ASSIGNEE"
  fi
  if [ -n "$GITHUB_REVIEWER" ]; then
    pr_opts+=(--reviewer "$GITHUB_REVIEWER")
    echo "Reviewer: $GITHUB_REVIEWER"
  fi

  gh pr create \
    --title "$COMMIT_TITLE" \
    --body-file "$PR_BODY_FILE" \
    --head "$BRANCH_NAME" \
    "${pr_opts[@]}"

  echo "--- Successfully created PR for flake update! ---"
else
  echo "Error: GitHub token (GH_TOKEN or GITHUB_TOKEN) is not available. Skipping PR creation." >&2
fi
