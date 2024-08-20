{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        height = 5;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["custom/spotify"];
        modules-right = ["network" "pulseaudio" "battery" "clock"];
        # Modules configuration
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          # persistent_workspaces = {
          #   1 = [];
          #   2 = [];
          #   3 = [];
          #   4 = [];
          #   5 = [];
          #   6 = [];
          #   7 = [];
          #   8 = [];
          #   9 = [];
          #   10 = []
          # };
          format-icons = {
            default = "";
            urgent = "";
            focused = "";
          };
        };
        "custom/spotify" = {
          format = "<span foreground='#E5B4E2'> </span><span font='OperatorMonoSSm Nerd Font weight=325 Italic'>{}</span>";
          interval = 1;
          exec-if = "pgrep spotify";
          on-click = "playerctl -p spotify play-pause";
          on-scroll-up = "playerctl -p spotify previous";
          on-scroll-down = "playerctl -p spotify next";
          tooltip = false;
          escape = true;
          max-length = 60;
          exec = "$HOME/bin/spotify.sh";
        };
        "clock" = {
          format = "<span foreground='#C6AAE8'> </span>{:%a %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {capacity}%";
          format-warning = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {capacity}%";
          format-critical = "<span size='13000' foreground='#E38C8F'>{icon}</span> {capacity}%";
          format-charging = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
          format-plugged = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
          format-alt = "<span size='13000' foreground='#B1E3AD'>{icon}</span> {time}";
          format-full = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{time}";
        };
        "network" = {
          format-wifi = "<span size='13000' foreground='#F2CECF'> </span>";
          format-ethernet = "<span size='13000' foreground='#F2CECF'>󰤭</span> Disconnected";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "<span size='13000' foreground='#F2CECF'> </span>Disconnected";
          tooltip-format-wifi = "Signal Strenght: {signalStrength}%";
        };
        "pulseaudio" = {
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          format = "<span size='13000' foreground='#EBDDAA'>{icon}</span> {volume}%";
          format-muted = "<span size='14000' foreground='#EBDDAA'></span> Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
        };
      };
    };
    style = pkgs.lib.readFile ./style.css;
  };
}
