{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.catppuccin.homeModules.catppuccin
    ./modules/vscode.nix
    ./modules/kitty.nix
    ./modules/spicetify.nix
    ./modules/fish.nix
    ./modules/gnome.nix
  ];

  home.username = "alexb";
  home.homeDirectory = "/home/alexb";

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "23.11";

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "peach";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
    typst
    typstyle
    tinymist
  ];

  programs.home-manager.enable = true;
}
