{
  config,
  settings,
  ...
}: {
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
    username = settings.username;
    homeDirectory = settings.homeDirectory;
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
