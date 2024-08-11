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
    # ./ags
  ];

  wayland.windowManager.hyprland.enable = true;
}
