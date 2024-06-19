{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./jellyfin.nix
    # ./jellyseer.nix
    ./media-collection.nix
  ];
}
