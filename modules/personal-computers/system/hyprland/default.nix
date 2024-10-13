{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./main.nix
    ./appearance.nix
    ./keybinds.nix
    # ./hyprpanel.nix
    # ./waybar/waybar.nix
    # ./ags
    ./rofi.nix
  ];

  wayland.windowManager.hyprland.enable = true;
}
