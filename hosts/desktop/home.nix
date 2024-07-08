{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../modules/personal-computers/home-manager/vscode.nix
    ../../modules/personal-computers/home-manager/kitty.nix
    ../../modules/personal-computers/system/gtk.nix
    ../../modules/personal-computers/system/gnome/gnome.nix
    ../../modules/personal-computers/system/zsh/zsh-desktop.nix
    ../../modules/personal-computers/system/nerdfonts.nix
  ];

  home.username = "alexb";
  home.homeDirectory = "/home/alexb";

  # Colour Scheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  nixpkgs.config.allowUnfree = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    firefox
    beeper
    stacer
    burpsuite
    image-roll
    google-chrome
    stacer
    bitwarden-desktop
    obs-studio
    nitch
    zoxide
    eza
    python3
    inotify-tools
    bun
    discord
    gparted
    arduino-cli
    arduino-ide
    nmap
    mullvad-vpn
    qbittorrent
    celluloid
    termius
    wireshark
    obs-studio
    prismlauncher
    steam-run
    protontricks
    lutris
    cartridges
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
