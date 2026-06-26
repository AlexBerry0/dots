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

  systemd.user.services.notes-backup = {
    Unit = {
      Description = "Automatic UC Notes background Git backup";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/Documents/UC/Notes/backup.sh";
    };
  };

  systemd.user.timers.notes-backup = {
    Unit = {
      Description = "Trigger UC Notes backup timer";
    };
    Timer = {
      OnCalendar = "*:0/30";
      Persistent = true;
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };

  programs.home-manager.enable = true;
}
