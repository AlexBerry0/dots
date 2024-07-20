{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./adguard-home.nix
    ./minecraft.nix
    ./homarr.nix
    ./flaresolverr.nix
  ];
}
