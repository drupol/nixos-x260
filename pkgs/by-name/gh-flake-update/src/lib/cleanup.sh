# shellcheck shell=bash

cleanup() {
  if [ -z "$TMP_DIR" ]; then
    return
  fi

  echo "--- Cleaning up ---"
  cd - >/dev/null 2>&1 || true
  if git worktree list | grep -q "$WORKTREE_DIR"; then
    echo "Removing git worktree at '$WORKTREE_DIR'..."
    git worktree remove --force "$WORKTREE_DIR"
  fi
  if git rev-parse --quiet --verify "$BRANCH_NAME" >/dev/null; then
    echo "Removing local branch '$BRANCH_NAME'..."
    git branch -D "$BRANCH_NAME"
  fi
  if [ -d "$TMP_DIR" ]; then
    echo "Removing temporary directory '$TMP_DIR'..."
    rm -rf "$TMP_DIR"
  fi
  echo "Cleanup complete."
}
