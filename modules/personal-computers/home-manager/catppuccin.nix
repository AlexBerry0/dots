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
    zsh.syntaxHighlighting.catppuccin.enable = true;
    rofi.catppuccin.enable = true;
  };

  wayland.windowManager.hyprland.catppuccin.enable = true;
}
