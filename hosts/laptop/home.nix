{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.catppuccin.homeModules.catppuccin
    ../../modules/personal-computers/home-manager/vscode.nix
    ../../modules/personal-computers/home-manager/alacritty.nix
    ../../modules/personal-computers/home-manager/kitty.nix
    ../../modules/personal-computers/home-manager/spicetify.nix
    ../../modules/personal-computers/home-manager/catppuccin.nix
    ../../modules/personal-computers/system/gtk.nix
    ../../modules/personal-computers/system/fish/fish-laptop.nix
    ../../modules/personal-computers/system/gnome/gnome.nix
    ../../modules/personal-computers/system/gnome/dconf/laptop.nix
    ../../modules/personal-computers/system/direnv.nix
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
    image-roll
    google-chrome
    obs-studio
    nitch
    zoxide
    eza
    dart-sass
    brightnessctl
    python3
    inotify-tools
    bun
    discord
    gparted
    arduino-cli
    nmap
    nodejs_22
    mullvad-vpn
    qbittorrent
    celluloid
    mediainfo
    foliate
    sops
    grimblast
    gpu-screen-recorder
    btop
    obsidian
    spotify-player
    pandoc
    qalculate-gtk
    tailscale
    trayscale
    brave
    steam-run
    rpi-imager
    kubectl
    kubernetes-helm
    kubeseal
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   ".config/hypr/hypridle.conf".source = ../../modules/personal-computers/system/hyprland/hypridle.conf;
  #   ".config/hypr/hyprlock.conf".source = ../../modules/personal-computers/system/hyprland/hyprlock.conf;
  # };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
