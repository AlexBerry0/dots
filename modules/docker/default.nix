{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./media
    ./adguard-home.nix
    # ./minecraft.nix
    ./homarr
  ];
}
