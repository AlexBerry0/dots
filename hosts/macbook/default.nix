{ pkgs, ... }: {
  imports = [
    ./homebrew.nix
    ../../modules/darwin/preferences.nix
  ];

  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "alexberry";
  security.pam.services.sudo_local.touchIdAuth = true;
  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  users.users.alexberry = {
    name = "alexberry";
    home = "/Users/alexberry";
    shell = pkgs.fish;
  };

  system.stateVersion = 5;
}