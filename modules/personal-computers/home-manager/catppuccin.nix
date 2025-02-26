{
  pkgs,
  config,
  ...
}: {
  catppuccin = {
    accent = "peach";
    flavor = "mocha";
    bottom.enable = true;
    kitty.enable = true;
    fish.enable = true;
    rofi.enable = true;
    fzf.enable = true;
  };

  # wayland.windowManager.hyprland.catppuccin.enable = true;
}
