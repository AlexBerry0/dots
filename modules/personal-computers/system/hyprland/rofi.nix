{
  lib,
  pkgs,
  ...
}:
with lib; {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
  };
}
