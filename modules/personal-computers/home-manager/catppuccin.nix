{
  pkgs,
  config,
  ...
}: {
  catppuccin = {
    accent = "peach";
    flavor = "mocha";
  };
  programs = {
    bottom.catppuccin.enable = true;
    kitty.catppuccin.enable = true;
    fish.catppuccin.enable = true;
    rofi.catppuccin.enable = true;
    fzf.catppuccin.enable = true;
  };

  # wayland.windowManager.hyprland.catppuccin.enable = true;
}
