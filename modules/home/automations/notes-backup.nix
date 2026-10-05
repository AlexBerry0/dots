{ pkgs, ... }:
let
  notesDir = "/Users/alexberry/Documents/Documents - Alexander’s MacBook Air/UC/Notes";
  backupScript = pkgs.writeShellScript "notes-backup" ''
    set -euo pipefail
    TARGET="${notesDir}"

    if [ ! -d "$TARGET/.git" ]; then
      exit 0
    fi

    cd "$TARGET"

    if [ -n "$(${pkgs.git}/bin/git status --porcelain)" ]; then
      ${pkgs.git}/bin/git add -A
      ${pkgs.git}/bin/git commit -m "Automatic Notes Backup: $(${pkgs.coreutils}/bin/date '+%Y-%m-%d %H:%M:%S')" || true
    fi

    LOCAL=$(${pkgs.git}/bin/git rev-parse @ 2>/dev/null || echo "")
    REMOTE=$(${pkgs.git}/bin/git rev-parse @{u} 2>/dev/null || echo "")

    if [ "$LOCAL" != "$REMOTE" ]; then
      ${pkgs.git}/bin/git push origin main
    fi
  '';
in {
  launchd.agents.notes-backup = {
    enable = true;
    config = {
      ProgramArguments = [ "${backupScript}" ];
      StartInterval = 1800;
      RunAtLoad = true;
      StandardOutPath = "/tmp/notes-backup.out";
      StandardErrorPath = "/tmp/notes-backup.err";
    };
  };
}