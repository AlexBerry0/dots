{pkgs, ...}: let
  dotsDir = "/Users/alexberry/Documents/Documents - Alexander’s MacBook Air/dots";

  updatePkg = pkgs.writeShellScriptBin "nix-auto-update" ''
    set -euo pipefail

    export PATH="/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/etc/profiles/per-user/alexberry/bin:$HOME/.nix-profile/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

    STATE_DIR="$HOME/.local/state"
    LAST_RUN="$STATE_DIR/nix-auto-update-last"
    SNOOZE_FILE="$STATE_DIR/nix-auto-update-snooze"
    mkdir -p "$STATE_DIR"

    TEST_MODE=0
    FORCE=0

    for arg in "$@"; do
      case "$arg" in
        --test)
          TEST_MODE=1
          FORCE=1
          ;;
        --force)
          FORCE=1
          ;;
      esac
    done

    log() {
      echo "[nix-auto-update] $1"
    }

    if [ "$TEST_MODE" -eq 1 ]; then
      log "Running in test mode..."
    fi

    # 1. Connectivity check
    PING_BIN=$(command -v ping 2>/dev/null || echo "/sbin/ping")
    if ! "$PING_BIN" -c 1 -t 2 1.1.1.1 >/dev/null 2>&1; then
      if [ "$TEST_MODE" -eq 1 ]; then
        log "Error: No internet connection."
      fi
      exit 0
    fi
    if [ "$TEST_MODE" -eq 1 ]; then
      log "Internet connection: OK"
    fi

    NOW=$(${pkgs.coreutils}/bin/date +%s)
    WEEK_SECONDS=$((7 * 24 * 3600))
    DAY_SECONDS=$((24 * 3600))

    if [ "$FORCE" -eq 0 ]; then
      if [ -f "$SNOOZE_FILE" ]; then
        SNOOZE_TIME=$(cat "$SNOOZE_FILE" 2>/dev/null || echo 0)
        if [ -n "$SNOOZE_TIME" ] && [ $((NOW - SNOOZE_TIME)) -lt $DAY_SECONDS ]; then
          exit 0
        fi
      fi

      if [ -f "$LAST_RUN" ]; then
        LAST_TIME=$(cat "$LAST_RUN" 2>/dev/null || echo 0)
        if [ -n "$LAST_TIME" ] && [ $((NOW - LAST_TIME)) -lt $WEEK_SECONDS ]; then
          exit 0
        fi
      fi
    fi

    # 2. Locate binaries
    NIX_BIN=""
    if [ -x "/nix/var/nix/profiles/default/bin/nix" ]; then
      NIX_BIN="/nix/var/nix/profiles/default/bin/nix"
    elif command -v nix >/dev/null 2>&1; then
      NIX_BIN=$(command -v nix)
    elif [ -x "$HOME/.nix-profile/bin/nix" ]; then
      NIX_BIN="$HOME/.nix-profile/bin/nix"
    elif [ -x "/run/current-system/sw/bin/nix" ]; then
      NIX_BIN="/run/current-system/sw/bin/nix"
    else
      log "Error: nix binary not found" >&2
      exit 1
    fi

    DARWIN_REBUILD_BIN=""
    if [ -x "/run/current-system/sw/bin/darwin-rebuild" ]; then
      DARWIN_REBUILD_BIN="/run/current-system/sw/bin/darwin-rebuild"
    elif command -v darwin-rebuild >/dev/null 2>&1; then
      DARWIN_REBUILD_BIN=$(command -v darwin-rebuild)
    elif [ -x "$HOME/.nix-profile/bin/darwin-rebuild" ]; then
      DARWIN_REBUILD_BIN="$HOME/.nix-profile/bin/darwin-rebuild"
    else
      log "Error: darwin-rebuild binary not found" >&2
      exit 1
    fi

    if [ "$TEST_MODE" -eq 1 ]; then
      log "Found nix: $NIX_BIN"
      log "Found darwin-rebuild: $DARWIN_REBUILD_BIN"
    fi

    # 3. Native macOS dialog via System Events
    ACTION=$(/usr/bin/osascript \
      -e 'try' \
      -e '  tell application "System Events"' \
      -e '    activate' \
      -e '    display dialog "Your weekly Nix system update is ready.\n\nThis will update flake inputs, rebuild the system with Touch ID, and push the updated lockfile to GitHub." with title "Nix System Update" buttons {"Postpone (24h)", "Update Now"} default button "Update Now" cancel button "Postpone (24h)" with icon note' \
      -e '  end tell' \
      -e '  return "UPDATE"' \
      -e 'on error number -128' \
      -e '  return "SNOOZE"' \
      -e 'end try'
    )

    if [ "$TEST_MODE" -eq 1 ]; then
      log "Selected action: $ACTION"
    fi

    if [ "$ACTION" != "UPDATE" ]; then
      echo "$NOW" > "$SNOOZE_FILE"
      if [ "$TEST_MODE" -eq 1 ]; then
        log "Snooze timestamp saved to $SNOOZE_FILE. Exiting."
      fi
      exit 0
    fi

    cd "${dotsDir}"

    # 4. Flake update (runs as user alexberry)
    if [ "$TEST_MODE" -eq 1 ]; then
      log "Updating flake inputs..."
    fi
    "$NIX_BIN" flake update --flake "${dotsDir}"

    # 5. Build system configuration (runs as user alexberry, avoiding libgit2 ownership errors)
    if [ "$TEST_MODE" -eq 1 ]; then
      log "Building new system profile as current user..."
    fi
    "$DARWIN_REBUILD_BIN" build --flake "${dotsDir}#macbook"

    # 6. Activate new profile (elevates via Touch ID / admin privileges only for activation)
    if [ "$TEST_MODE" -eq 1 ]; then
      log "Activating system profile with administrator privileges..."
    fi
    ACTIVATE_CMD="PATH=\"$PATH\" \"${dotsDir}/result/activate\""
    /usr/bin/osascript \
      -e 'on run argv' \
      -e '  do shell script (item 1 of argv) with administrator privileges' \
      -e 'end run' \
      "$ACTIVATE_CMD"

    # Clean up local result symlink
    rm -f "${dotsDir}/result"

    # 7. Commit and push lockfile
    if ! ${pkgs.git}/bin/git diff --quiet flake.lock; then
      if [ "$TEST_MODE" -eq 1 ]; then
        log "flake.lock changed; committing and pushing..."
      fi
      ${pkgs.git}/bin/git add flake.lock
      ${pkgs.git}/bin/git commit -m "chore(flake): weekly automated flake update"
      CURRENT_BRANCH=$(${pkgs.git}/bin/git branch --show-current 2>/dev/null || echo "master")
      ${pkgs.git}/bin/git push origin "$CURRENT_BRANCH" || ${pkgs.git}/bin/git push
    fi

    echo "$NOW" > "$LAST_RUN"
    rm -f "$SNOOZE_FILE"

    /usr/bin/osascript -e 'display notification "Your system has been successfully rebuilt and updated." with title "Nix Update Succeeded"'

    if [ "$TEST_MODE" -eq 1 ]; then
      log "Update process finished successfully."
    fi
  '';
in {
  home.packages = [updatePkg];

  launchd.agents.nix-auto-update = {
    enable = true;
    config = {
      ProgramArguments = ["${updatePkg}/bin/nix-auto-update"];
      EnvironmentVariables = {
        PATH = "/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/etc/profiles/per-user/alexberry/bin:/Users/alexberry/.nix-profile/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
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
