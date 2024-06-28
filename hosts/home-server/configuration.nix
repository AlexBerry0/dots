{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/docker
    ../../modules/nixos/nixarr.nix
    inputs.nixarr.nixosModules.default
    # ../../modules/nixos/vpn-confinement.nix
    # inputs.vpnconfinement.nixosModules.default
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKLIih372Gsw7g7XckXJasKYqlM17+4QhTlss24+DUH alexb@alexslaptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKwx9jMNPQr0N3Kf1k1lWPVl6jDgJdYiD6yw6vWUvE0 alexb@nixos"
    ];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "user" = import ./home.nix;
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    git
    wireguard-tools
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = true;
  };
  system.stateVersion = "23.11";

  networking.nat.enable = false;
  networking.nat.internalInterfaces = ["wg"];
  networking.nftables.enable = false;
  networking.firewall = {
    enable = true;
  };
}
