{pkgs, ...}: {
  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/fish.nix
    ../../modules/home/starship.nix
    ../../modules/home/ghostty.nix
    ../../modules/home/vscode.nix
    ../../modules/home/neovim/default.nix
    ../../modules/home/automations/notes-backup.nix
    ../../modules/home/automations/auto-update.nix
  ];

  home = {
    username = "alexberry";
    homeDirectory = "/Users/alexberry";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
