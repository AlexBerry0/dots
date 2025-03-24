{
  config,
  pkgs,
  inputs,
  ...
}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = [
      pkgs.hplip
      # pkgs.hplipWithPlugin
    ];
    extraConf = ''
      ErrorPolicy retry-job
    '';
  };

  # nixpkgs.config.allowUnfreePredicate = pkg:
  #   builtins.elem (builtins.parseDrvName pkg.name).name ["hplip"];
  # nixpkgs.overlays = [(final: prev: {hplip = prev.hplip.override {withQt5 = false;};})];

  networking.firewall.allowedTCPPorts = [631];
}
