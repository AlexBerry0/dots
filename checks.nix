{
  pkgs,
  settings,
  homeConfig,
}: let
  updater = builtins.head homeConfig.launchd.agents.nix-auto-update.config.ProgramArguments;
  notes = builtins.head homeConfig.launchd.agents.notes-backup.config.ProgramArguments;
  take = pkgs.writeText "take.fish" ''
    function take
    ${homeConfig.programs.fish.functions.take}
    end
  '';
in
  pkgs.runCommand "configuration-checks" {
    nativeBuildInputs = [pkgs.shellcheck pkgs.fish pkgs.python3 pkgs.git];
    UPDATER_SCRIPT = updater;
    NOTES_SCRIPT = notes;
    TAKE_SCRIPT = take;
    FISH_BIN = "${pkgs.fish}/bin/fish";
    GIT_BIN = "${pkgs.git}/bin/git";
    REPO_DIR = settings.repoDir;
    NOTES_DIR = settings.notesDir;
  } ''
    shellcheck -s bash "$UPDATER_SCRIPT" "$NOTES_SCRIPT"
    fish --no-execute "$TAKE_SCRIPT"
    python3 ${./tests/test_automations.py}
    touch "$out"
  ''
