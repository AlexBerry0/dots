{
  pkgs,
  settings,
  ...
}: let
  backupScript = pkgs.writeShellScript "notes-backup" ''
    set -euo pipefail
    export GIT_TERMINAL_PROMPT=0
    GIT_BIN="${pkgs.git}/bin/git"
    log() { echo "[notes-backup] $*"; }
    TARGET="${settings.notesDir}"

    if [ ! -d "$TARGET" ]; then
      log "Notes directory is unavailable; skipping."
      exit 0
    fi
    cd "$TARGET"
    if ! "$GIT_BIN" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      log "Notes directory is not a Git working tree." >&2
      exit 1
    fi
    # Do not accidentally back up a parent repository if Notes loses its .git entry.
    TOPLEVEL=$("$GIT_BIN" rev-parse --show-toplevel)
    if [ "$TOPLEVEL" != "$(pwd -P)" ]; then
      log "Notes must be the root of their own repository." >&2
      exit 1
    fi
    BRANCH=$("$GIT_BIN" symbolic-ref --quiet --short HEAD) || {
      log "Detached HEAD; switch to ${settings.notesBranch} before backing up." >&2
      exit 1
    }
    if [ "$BRANCH" != "${settings.notesBranch}" ]; then
      log "Expected branch ${settings.notesBranch}; found $BRANCH. Skipping."
      exit 0
    fi
    REMOTE=$("$GIT_BIN" config --get "branch.$BRANCH.remote") || {
      log "No upstream remote configured for $BRANCH." >&2
      exit 1
    }
    MERGE_REF=$("$GIT_BIN" config --get "branch.$BRANCH.merge") || {
      log "No upstream branch configured for $BRANCH." >&2
      exit 1
    }
    case "$REMOTE:$MERGE_REF" in
      .:*|:*|*:|*:refs/heads/) log "Invalid upstream configuration." >&2; exit 1 ;;
    esac
    case "$MERGE_REF" in
      refs/heads/*) ;;
      *) log "Upstream must be a branch." >&2; exit 1 ;;
    esac

    # Fetch the exact destination; never merge/rebase automatically into working notes.
    "$GIT_BIN" fetch -- "$REMOTE" "$MERGE_REF"
    REMOTE_TIP=$("$GIT_BIN" rev-parse FETCH_HEAD)
    if ! "$GIT_BIN" merge-base --is-ancestor "$REMOTE_TIP" HEAD; then
      log "Upstream has changes not in this checkout. Reconcile them manually before backup." >&2
      exit 1
    fi

    STATUS=$("$GIT_BIN" status --porcelain)
    if [ -n "$STATUS" ]; then
      # Retain the existing whole-repository backup scope.
      "$GIT_BIN" add -A
      if ! "$GIT_BIN" diff --cached --quiet; then
        "$GIT_BIN" commit -m "Automatic Notes Backup: $(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')"
      fi
    fi
    LOCAL_TIP=$("$GIT_BIN" rev-parse HEAD)
    if [ "$LOCAL_TIP" != "$REMOTE_TIP" ]; then
      "$GIT_BIN" push -- "$REMOTE" "HEAD:$MERGE_REF"
      log "Backed up $BRANCH to $REMOTE/$MERGE_REF."
    else
      log "Notes are already backed up."
    fi
  '';
in {
  launchd.agents.notes-backup = {
    enable = true;
    config = {
      ProgramArguments = ["${backupScript}"];
      StartInterval = 1800;
      RunAtLoad = true;
      StandardOutPath = "/tmp/notes-backup.out";
      StandardErrorPath = "/tmp/notes-backup.err";
    };
  };
}
