{
  inputs,
  lib,
  pkgs,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      welcome-dialog-last-shown-version = "99.9";
    };

    "org/gnome/desktop/wm/preferences" = {
      auto-raise = false;
      button-layout = "close,minimize,maximize:";
      focus-mode = "click";
      num-workspaces = 1;
      resize-with-right-button = false;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = false;
      overlay-key = "Super_L";
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file:///etc/nixos/media/space_saturn.png";
      # picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    };

    "org/gnome/desktop/interface" = {
      scaling-factor = lib.hm.gvariant.mkUint32 1;
      clock-format = "12h";
    };

    "org/gnome/desktop/datetime" = {
      time-format = "custom";
      custom-time-format = "%m-%d %H:%M";
      automatic-timezone = false;
    };

    # Keyboard shortcuts

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kitty";
      name = "Kitty - Terminal";
    };
  };
}
