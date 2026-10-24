{
  pkgs,
  settings,
  ...
}: let
  dotsDir = settings.repoDir;

  updatePkg = pkgs.writeShellScriptBin "nix-auto-update" ''
    set -euo pipefail
    export PATH="/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin"

    log() { echo "[nix-auto-update] $*"; }
    TEST_MODE=0
    FORCE=0
    for arg in "$@"; do
      case "$arg" in
        --test) TEST_MODE=1 ;;
        --force) FORCE=1 ;;
        *) log "Unknown argument: $arg" >&2; exit 2 ;;
      esac
    done

    NIX_BIN=$(command -v nix)
    NIX_ENV_BIN=$(command -v nix-env)
    GIT_BIN="${pkgs.git}/bin/git"
    STATE_DIR="$HOME/.local/state/nix-auto-update"
    # Retain the existing weekly and snooze timestamps.
    LAST_RUN="$HOME/.local/state/nix-auto-update-last"
    SNOOZE_FILE="$HOME/.local/state/nix-auto-update-snooze"

    cd "${dotsDir}"
    if [ "$TEST_MODE" -eq 1 ]; then
      log "Diagnostics only: checking the locked configuration; no update, dialog, activation, commit or push."
      "$NIX_BIN" eval --no-write-lock-file --raw \
        "${dotsDir}#darwinConfigurations.${settings.hostName}.system.drvPath"
      echo
      log "Diagnostics passed."
      exit 0
    fi

    # Nix flakes omit untracked files; do not update or activate pending work.
    STATUS=$("$GIT_BIN" status --porcelain)
    if [ -n "$STATUS" ]; then
      log "Repository has unreviewed changes; review and commit or stash them before updating."
      exit 0
    fi
    NOW=$(${pkgs.coreutils}/bin/date +%s)
    if [ "$FORCE" -eq 0 ]; then
      for entry in "$SNOOZE_FILE:86400" "$LAST_RUN:604800"; do
        stamp_file="''${entry%:*}"
        interval="''${entry##*:}"
        if [ -f "$stamp_file" ]; then
          stamp=$(cat "$stamp_file")
          case "$stamp" in
            ""|*[!0-9]*) log "Ignoring invalid timestamp in $stamp_file" ;;
            *) if [ "$((NOW - stamp))" -lt "$interval" ]; then exit 0; fi ;;
          esac
        fi
      done
    fi

    mkdir -p "$STATE_DIR"
    # launchd serializes scheduled runs; also guard against a manual run overlapping.
    if ! mkdir "$STATE_DIR/running" 2>/dev/null; then
      log "An update is already running. If a previous run crashed, remove $STATE_DIR/running."
      exit 0
    fi
    RUN_DIR=""
    cleanup() {
      if [ -n "$RUN_DIR" ]; then rm -rf "$RUN_DIR"; fi
      rmdir "$STATE_DIR/running"
    }
    trap cleanup EXIT
    trap 'log "Update failed. See the launchd error log; any changed lockfile is left for review." >&2' ERR
    RUN_DIR=$(${pkgs.coreutils}/bin/mktemp -d "$STATE_DIR/run.XXXXXX")

    # Standard Additions can show the dialog without sending Apple Events to System Events.
    ACTION=$(/usr/bin/osascript <<'APPLESCRIPT'
    try
      display dialog "Update the Nix flake and rebuild this Mac? Administrator authentication is required to apply it. The updated lockfile will stay local for review." with title "Nix System Update" buttons {"Postpone (24h)", "Update Now"} default button "Update Now" cancel button "Postpone (24h)" with icon note
      return "UPDATE"
    on error number -128
      return "SNOOZE"
    end try
    APPLESCRIPT
    )
    if [ "$ACTION" != "UPDATE" ]; then
      echo "$NOW" > "$SNOOZE_FILE"
      log "Postponed for 24 hours."
      exit 0
    fi

    # Recheck after the dialog, which may have been left open while files changed.
    STATUS=$("$GIT_BIN" status --porcelain)
    if [ -n "$STATUS" ]; then
      log "Repository changed while waiting for approval; leaving it untouched."
      exit 0
    fi
    cp flake.lock "$RUN_DIR/flake.lock"
    log "Updating flake inputs..."
    "$NIX_BIN" flake update --flake "${dotsDir}"
    log "Building the updated configuration as the current user..."
    if ! "$NIX_BIN" build --no-write-lock-file --out-link "$RUN_DIR/result" \
      "${dotsDir}#darwinConfigurations.${settings.hostName}.system"; then
      cp "$RUN_DIR/flake.lock" flake.lock
      log "Build failed; restored the previous lockfile. The running system was not changed." >&2
      exit 1
    fi
    BUILT_SYSTEM=$(${pkgs.coreutils}/bin/readlink -f "$RUN_DIR/result")

    log "Requesting administrator authentication to record and activate the built system..."
    /usr/bin/osascript - "$NIX_ENV_BIN" "$BUILT_SYSTEM" <<'APPLESCRIPT'
    on run argv
      set nixEnv to quoted form of (item 1 of argv)
      set systemPath to item 2 of argv
      set activateCommand to quoted form of (systemPath & "/sw/bin/darwin-rebuild")
      do shell script (nixEnv & " -p /nix/var/nix/profiles/system --set " & quoted form of systemPath & " && " & activateCommand & " activate") with administrator privileges
    end run
    APPLESCRIPT

    ${pkgs.coreutils}/bin/date +%s > "$LAST_RUN"
    rm -f "$SNOOZE_FILE"
    log "System updated. Review flake.lock locally; nothing was committed or pushed."
    /usr/bin/osascript -e 'display notification "System updated. Review flake.lock before committing." with title "Nix Update Succeeded"' || true
  '';
in {
  home.packages = [updatePkg];

  launchd.agents.nix-auto-update = {
    enable = true;
    config = {
      ProgramArguments = ["${updatePkg}/bin/nix-auto-update"];
      StartCalendarInterval = [
        {
          Hour = 10;
          Minute = 0;
        }
      ];
      StandardOutPath = "/tmp/nix-auto-update.out";
      StandardErrorPath = "/tmp/nix-auto-update.err";
    };
  };
}
