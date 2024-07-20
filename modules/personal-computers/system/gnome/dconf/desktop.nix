{
  inputs,
  lib,
  pkgs,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "beeper.desktop"
        "page.kramo.Cartridges.desktop"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      always-center-icons = true;
      animation-time = 0.24999999999999967;
      apply-custom-theme = true;
      autohide-in-fullscreen = false;
      background-color = "rgb(255,255,255)";
      background-opacity = 0.5;
      border-radius = 28;
      click-action = "focus-minimize-or-previews";
      custom-background-color = true;
      custom-theme-customize-running-dots = false;
      custom-theme-shrink = false;
      customize-alphas = true;
      dash-max-icon-size = 72;
      dock-position = "BOTTOM";
      extend-height = false;
      floating-margin = 5;
      force-straight-corner = false;
      height-fraction = 0.90000000000000002;
      hide-delay = 1.0;
      hot-keys = true;
      icon-size-fixed = true;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      isolate-monitors = false;
      isolate-workspaces = false;
      max-alpha = 0.78000000000000003;
      middle-click-action = "launch";
      min-alpha = 0.29999999999999999;
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      preview-size-scale = 0.0;
      require-pressure-to-show = false;
      running-indicator-dominant-color = false;
      running-indicator-style = "DOTS";
      scroll-action = "cycle-windows";
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-apps-at-top = true;
      show-delay = 0.20000000000000001;
      show-favorites = true;
      show-mounts = false;
      show-mounts-network = true;
      show-show-apps-button = true;
      show-trash = false;
      transparency-mode = "DYNAMIC";
      unity-backlit-items = false;
    };
  };
}
