{
  pkgs,
  settings,
  ...
}: let
  # Rules are read from the working copy so edits apply on the next run without a rebuild.
  rulesFile = "${settings.repoDir}/modules/home/automations/mail-sort/rules.json";
  sorter = pkgs.writeShellScriptBin "mail-sort" ''
    exec ${pkgs.python3}/bin/python3 -I ${./mail-sort/mail_sort.py} --rules "${rulesFile}" "$@"
  '';
in {
  home.packages = [sorter];

  launchd.agents.mail-sort = {
    enable = true;
    config = {
      ProgramArguments = ["${sorter}/bin/mail-sort"];
      StartInterval = 3600;
      StandardOutPath = "/tmp/mail-sort.out";
      StandardErrorPath = "/tmp/mail-sort.err";
    };
  };
}
