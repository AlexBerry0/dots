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
    ../../modules/personal-computers/home-manager/spicetify.nix
    ../../modules/personal-computers/system/gtk.nix
    ../../modules/personal-computers/system/gnome/gnome.nix
    ../../modules/personal-computers/system/zsh/zsh-desktop.nix
    ../../modules/personal-computers/system/nerdfonts.nix
    ../../modules/personal-computers/system/gnome/dconf/desktop.nix
  ];

  home.username = "alexb";
  home.homeDirectory = "/home/alexb";

  # Colour Scheme
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "23.11";

  # Packages installed with Home-manager
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
