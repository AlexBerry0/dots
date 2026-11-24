{
  lib,
  pkgs,
  settings,
  ...
}: let
  # Encrypts and uploads anything dropped in ~/Documents/Library Inbox.
  # Runs from the working copy so edits to the library apply without a rebuild.
  syncScript = pkgs.writeShellScript "library-sync" ''
    set -eu
    umask 077
    # Apple's ssh reads the key passphrase from the Keychain.
    export PATH="${lib.makeBinPath [pkgs.git pkgs.sops]}:/usr/bin:/bin"
    export GIT_TERMINAL_PROMPT=0
    export GIT_SSH_COMMAND="/usr/bin/ssh -o BatchMode=yes"
    LIBRARY="${settings.libraryDir}/library"
    if [ ! -f "$LIBRARY" ]; then
      echo "[library-sync] Library is unavailable; skipping."
      exit 0
    fi
    exec ${pkgs.python3}/bin/python3 "$LIBRARY" sync --auto
  '';
  logDir = "${settings.homeDirectory}/Library/Logs";
in {
  launchd.agents.library-sync = {
    enable = true;
    config = {
      ProgramArguments = ["${syncScript}"];
      StartInterval = 300;
      WatchPaths = ["${settings.homeDirectory}/Documents/Library Inbox"];
      StandardOutPath = "${logDir}/library-sync.out";
      StandardErrorPath = "${logDir}/library-sync.err";
    };
  };
}
