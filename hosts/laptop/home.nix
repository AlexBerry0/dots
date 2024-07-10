{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../modules/personal-computers/home-manager/vscode.nix
    ../../modules/personal-computers/home-manager/alacritty.nix
    ../../modules/personal-computers/home-manager/kitty.nix
    ../../modules/personal-computers/home-manager/jetbrains.nix
    ../../modules/personal-computers/system/gtk.nix
    ../../modules/personal-computers/system/gnome/gnome.nix
    ../../modules/personal-computers/system/zsh/zsh-laptop.nix
    ../../modules/personal-computers/system/nerdfonts.nix
    ../../modules/personal-computers/system/hyprland
    ../../modules/personal-computers/system/gnome/dconf/laptop.nix
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
    github-desktop
    postman
    bitwarden-desktop
    obs-studio
    nitch
    zoxide
    eza
    hypridle
    hyprlock
    swaybg
    dart-sass
    sassc
    brightnessctl
    python3
    inotify-tools
    bun
    discord
    gparted
    arduino-cli
    arduino-ide
    nmap
    nix-prefetch-github
    nix-prefetch
    nodejs_22
    mullvad-vpn
    qbittorrent
    celluloid
    nodePackages.sloc
    termius
    exiftool
    mediainfo
    wireshark
    delfin
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/hypridle.conf".source = ../../modules/personal-computers/system/hyprland/hypridle.conf;
    ".config/hypr/hyprlock.conf".source = ../../modules/personal-computers/system/hyprland/hyprlock.conf;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
