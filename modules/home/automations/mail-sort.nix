{
  pkgs,
  settings,
  ...
}: let
  # The rules name people, banks and accounts, so they stay out of this public repository.
  rulesFile = "${settings.homeDirectory}/.config/mail-sort/rules.json";
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
