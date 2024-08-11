{
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$browser" = "firefox";
    "$editor" = "code";

    # "$volume" = "${../scripts/volume.sh}";
    # "$brightness" = "${../scripts/brightness.sh}";
    # "$screen_rec" = "${../scripts/screen-record.sh}";
    # "$kbd_backlight_name" = "kbd_backlight";

    exec-once = [
      "hypridle"
      "ags"
    ];

    exec = [
      "swaybg -i ${../../../../media/space_saturn.png}"
    ];

    debug = {
      disable_logs = false;
    };

    general = {
      layout = "dwindle";
      allow_tearing = false;
    };

    input = {
      kb_layout = "us";

      follow_mouse = 1;

      touchpad = {
        natural_scroll = true;
        clickfinger_behavior = true;
        tap-to-click = true;
      };

      sensitivity = 0;
    };

    gestures = {
      workspace_swipe = "on";
      workspace_swipe_cancel_ratio = 0.3;
    };

    dwindle = {
      pseudotile = "yes";
      preserve_split = "yes";
    };

    windowrulev2 = ["suppressevent maximize, class:.*"];

    monitor = [", preferred, auto, auto"];

    env = ["QT_QPA_PLATFORMTHEME,qt5ct"];

    misc = {
      force_default_wallpaper = 0;
      vfr = "on";
    };
    xwayland = {
      force_zero_scaling = "on";
    };
  };
}
