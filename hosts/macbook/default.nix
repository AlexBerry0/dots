{
  pkgs,
  settings,
  ...
}: {
  imports = [
    ./homebrew.nix
    ../../modules/darwin/preferences.nix
  ];

  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = settings.username;
  security.pam.services.sudo_local.touchIdAuth = true;
  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  users.users.${settings.username} = {
    name = settings.username;
    home = settings.homeDirectory;
    shell = pkgs.fish;
  };

  system.stateVersion = 5;
}
