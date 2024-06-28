{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./modules/openvpn.nix
    ../../modules/nixos/zsh-server.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    htop
    nitch
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
