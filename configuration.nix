{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ./modules/steam.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    timeout = 5;
    grub = {
      enable = true;
      theme = pkgs.sleek-grub-theme.override {
        withBanner = "Hello Alex,";
        withStyle = "dark";
      };
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = ["nodev"];
      useOSProber = true;
    };
  };

  environment.variables.XCURSOR_SIZE = "22";

  # Networking
  networking.networkmanager.enable = true;
  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlo1";

  networking = {
    hostName = "alexslaptoplinux";
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };

  time.timeZone = "Pacific/Auckland";

  catppuccin = {
    enable = true;
    autoEnable = false;
  };

  gtk.iconCache.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # SDDM
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [
      qtsvg
      qtmultimedia
      qtvirtualkeyboard
    ];
  };

  # GNOME
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-console
    gnome-photos
    gnome-tour
    gnome-connections
    snapshot
    gedit
    cheese
    epiphany
    geary
    yelp
    totem
    gnome-font-viewer
    gnome-music
    gnome-characters
    tali
    iagno
    hitori
    atomix
    gnome-contacts
    gnome-initial-setup
    gnome-shell-extensions
    gnome-maps
  ];

  services.tailscale.enable = true;

  # Printing & Avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
    extraConf = ''
      ErrorPolicy retry-job
    '';
  };
  networking.firewall.allowedTCPPorts = [631];

  # Sounds
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;

  # nh tools
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
  };

  # Fonts
  fonts = {
    fontconfig.enable = true;
    packages = [pkgs.nerd-fonts.hack];
  };

  # Users
  users.users.alexb = {
    isNormalUser = true;
    description = "Alex Berry";
    extraGroups = ["networkmanager" "wheel" "docker" "libvirtd"];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "alexb" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    polkit
    polkit_gnome
    git
    qt5.qtquickcontrols2
    qt5.qtgraphicaleffects
    sops
    bottom
    ocaml
    opam
    rustup
    cargo
    k3d
    libgcc
    gnumake
    kubeseal
    k3s
    openiscsi
    minikube
    qemu_kvm
    docker
    podman
    nerd-fonts.hack
    (sddm-astronaut.override {
      themeConfig = {
        Background = "${./media/space_saturn.png}";
        FormPosition = "left";
        MainColor = "#fab387";
      };
    })
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  environment.pathsToLink = ["/bin" "/share/qemu"];

  services.openiscsi = {
    enable = true;
    name = "iqn.2024-01.io.k3d:nixos-host";
  };

  security.polkit.enable = true;
  networking.firewall.trustedInterfaces = ["virbr0"];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  systemd.user.services."gtk-fix" = {
    script = ''
      rm -f /home/alexb/.config/gtk-4.0/gtk.css || true
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = ["multi-user.target"];
  };

  home-manager.backupFileExtension = "backup";
  system.stateVersion = "23.11";
}
