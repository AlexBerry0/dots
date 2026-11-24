{pkgs, ...}: let
  # The App Store closes WheelClick to update it and never opens it again.
  # It is only opened when it isn't running, because opening it twice shows its window.
  keepScript = pkgs.writeShellScript "keep-wheelclick" ''
    set -eu
    APP=/Applications/WheelClick.app
    [ -d "$APP" ] || exit 0
    /usr/bin/pgrep -xq WheelClick && exit 0
    # Fails while an update is being installed; the next run tries again.
    /usr/bin/open -gj "$APP" || true
  '';
in {
  launchd.agents.keep-wheelclick = {
    enable = true;
    config = {
      ProgramArguments = ["${keepScript}"];
      RunAtLoad = true;
      StartInterval = 60;
    };
  };
}
