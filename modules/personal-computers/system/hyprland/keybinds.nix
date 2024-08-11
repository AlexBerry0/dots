{
  wayland.windowManager.hyprland.settings = let
    binding = mods: type: key: arg: "${mods}, ${key}, ${type}, ${arg}";
    move-focus = binding "$mainMod" "movefocus";
    resize-active = binding "$mainMod ALT SHIFT" "resizeactive";
    move-to-ws = binding "$mainMod SHIFT" "movetoworkspace";
    go-to-ws = mods: binding "$mainMod ${mods}" "workspace";
    move-window = binding "$mainMod SHIFT" "movewindow";

    range = n: builtins.genList (i: i) n;

    left = "j";
    right = "l";
    arrows = [left "k" "i" right];

    arrows-for = binding-func: args:
      map
      (i: binding-func (builtins.elemAt arrows i) (builtins.elemAt args i))
      (range 4);

    workspaces = range 10;

    bash-get-date = "$(date +%Y%m%d-%H%M%S)";

    screen-capture-binds = [
      "$mainMod, S, exec, IMG=~/Pictures/Screenshots/screenshot-${bash-get-date}.png && grim $IMG && wl-copy < $IMG" # Screenshot the whole screen then copy to clipboard
      "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | swappy -f -" # Screenshot selected area then open with swappy
      "$mainMod ALT, S, exec, $screen_rec ~/Videos/Screen\\ Recordings/screenrec-${bash-get-date}.mp4" # Record selected area
      "$mainMod ALT SHIFT, S, exec, killall -s SIGINT wf-recorder" # Stop recording
    ];

    lockscreen-screen-capture = true;
  in {
    "$mainMod" = "SUPER";

    bind =
      [
        # Apps
        "$mainMod, Return, exec, $terminal"
        "$mainMod, W, exec, $browser"
        "$mainMod, E, exec, $editor"

        # WM (these are all default)
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        # Misc
        "$mainMod, B, exec, hyprctl dispatch toggleopaque"
        "$mainMod CTRL, L, exec, hyprlock"
        # "$mainMod, A, exec, ags -t applauncher"

        (go-to-ws "CTRL" left "e-1")
        (go-to-ws "CTRL" right "e+1")
      ]
      ++ (arrows-for move-focus ["l" "d" "u" "r"])
      ++ (arrows-for move-window ["l" "d" "u" "r"])
      ++ (map (i: move-to-ws (toString i) (toString i)) workspaces)
      ++ (map (i: go-to-ws "" (toString i) (toString i)) workspaces)
      ++ (
        if lockscreen-screen-capture
        then []
        else screen-capture-binds
      );

    binde =
      [
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioMute, exec, $volume toggle"
      ]
      ++ (arrows-for resize-active ["-20 0" "0 20" "0 -20" "20 0"]);

    # bindle = [
    #   ", XF86AudioLowerVolume, exec, $volume down"
    #   ", XF86AudioRaiseVolume, exec, $volume up"
    #   ", XF86MonBrightnessDown, exec, $brightness down"
    #   ", XF86MonBrightnessUp, exec, $brightness up"
    #   "$mainMod, XF86MonBrightnessDown, exec, $brightness down $kbd_backlight_name"
    #   "$mainMod, XF86MonBrightnessUp, exec, $brightness up $kbd_backlight_name"
    # ];

    bindl =
      if lockscreen-screen-capture
      then screen-capture-binds
      else [];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod SHIFT, mouse:272, resizewindow"
    ];
  };
}
