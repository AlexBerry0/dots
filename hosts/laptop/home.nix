{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/nixos/gtk.nix
    ../../modules/nixos/gnome.nix
    ../../modules/nixos/zsh.nix
    ../../modules/nixos/nerdfonts.nix
    ../../modules/nixos/hyprland
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr/hypridle.conf".source = ../../modules/nixos/hyprland/hypridle.conf;
    ".config/hypr/hyprlock.conf".source = ../../modules/nixos/hyprland/hyprlock.conf;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
