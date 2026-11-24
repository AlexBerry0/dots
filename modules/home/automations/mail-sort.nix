{
  lib,
  pkgs,
  settings,
  ...
}: let
  # The sorter is a private repository, cloned here and run from the working copy,
  # so edits to it apply without a rebuild. A flake input would be fetched by root
  # during a rebuild and would stop anyone else evaluating this public flake.
  dir = settings.mailSortDir;
  # The rules name people, banks and accounts, so they stay out of git entirely.
  rulesFile = "${settings.homeDirectory}/.config/mail-sort/rules.json";
  install = pkgs.writeShellScript "mail-sort-install" ''
    set -eu
    [ -e "${dir}" ] && exit 0
    export GIT_TERMINAL_PROMPT=0
    # Apple's ssh reads the key passphrase from the Keychain.
    export GIT_SSH_COMMAND="/usr/bin/ssh -o BatchMode=yes"
    mkdir -p "$(dirname "${dir}")"
    exec ${pkgs.git}/bin/git clone --quiet ${settings.mailSortRepo} "${dir}"
  '';
  sorter = pkgs.writeShellScriptBin "mail-sort" ''
    export PATH="${lib.makeBinPath [pkgs.coreutils]}:/usr/bin:/bin"
    if ! ${install}; then
      echo "[mail-sort] Could not install the sorter from its repository; skipping."
      exit 0
    fi
    exec ${pkgs.python3}/bin/python3 -I "${dir}/mail_sort.py" --rules "${rulesFile}" "$@"
  '';
in {
  home.packages = [sorter];

  # Failing here must not block a rebuild; the hourly run tries again.
  home.activation.installMailSort = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${install} || warnEcho "mail-sort could not be installed; it will be tried again on the next run."
  '';

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
