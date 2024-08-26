{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nix-colors.homeManagerModules.default
    inputs.home-manager.nixosModules.default
    ../../modules/personal-computers/system/printing.nix
    ../../modules/personal-computers/services
    ../../modules/personal-computers/home-manager/steam.nix
    ../../modules/common/nh.nix
    # inputs.sops-nix.nixosModules.sops
  ];

  # SOPS
  # sops.defaultSopsFile = ./secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";

  # sops.age.keyFile = "/home/alexb/.config/sops/age/keys.txt";

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
      efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
      devices = ["nodev"];
      useOSProber = true;
    };
  };

  environment.variables.XCURSOR_SIZE = "22";

  # Networking
  networking.networkmanager.enable = true;
  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlo1";
  networking.hostName = "alexslaptoplinux";

  # Mullvad config, currently commented out as I don't use it and it seems to break captive browser
  services.mullvad-vpn.enable = true;

  # networking.nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
  # services.resolved = {
  #   enable = true;
  #   dnssec = "true";
  #   domains = ["~."];
  #   fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
  #   dnsovertls = "true";
  # };

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Select internationalisation properties.
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

  # SDDM
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "${import ../../pkgs/sddm-sugar-dark.nix {inherit pkgs;}}";

  # GNOME
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages =
    (with pkgs; [
      # gnome-text-editor
      gnome-console
      gnome-photos
      gnome-tour
      gnome-connections
      snapshot
      gedit
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      # evince # document viewer
      yelp # Help view
      totem # video player
      gnome-font-viewer
    ])
    ++ (with pkgs.gnome; [
      gnome-music
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      gnome-initial-setup
      gnome-shell-extensions
      gnome-maps
    ]);

  # Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Sounds
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;

  # Users
  users.users.alexb = {
    isNormalUser = true;
    description = "Alex Berry";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };

  # system.activationScripts.script.text = "
  #   mkdir /var/lib/AccountsService/icons/alexb && cp /etc/nixos/media/" here ye go [blue].png " /var/lib/AccountsService/icons/alexb
  #  ";

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "alexb" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    polkit
    polkit_gnome
    git
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    sops
    bottom
    ocaml
    rustup
    cargo
    libgcc
  ];

  security.polkit.enable = true;

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

  system.stateVersion = "23.11";
}
