# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c4acfe69-cd01-45db-8a99-2d75307c5ce1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FDEC-AFD6";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/mnt/library" = {
    device = "/dev/disk/by-uuid/627c2049-5b72-410d-baa8-4740eab7e865";
    fsType = "ext4";
  };

  fileSystems."/mnt/drive2" = {
    device = "/dev/disk/by-uuid/a106cdfc-6f26-4436-8faa-e7f4b4173348";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/41c0ae5f-2476-43a3-bee5-e4d39bc21d0c";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-8aea26a4a5c7.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-c317723932ba.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-df791ede360c.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth-wg-br.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth44ca76d.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethb425da1.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethfb11927.useDHCP = lib.mkDefault true;
  # networking.interfaces.wg-br.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f0u3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
