{
  config,
  inputs,
  ...
}: {
  systemd.services."wg-mover" = {
    script = ''
      echo "
      $(cat ${config.sops.secrets."nixarr/wgconf".path})
      " > /var/lib/wg-mover/wg.conf
    '';
    serviceConfig = {
      User = "wg-mover";
      WorkingDirectory = "/var/lib/wg-mover";
    };
  };

  users.users.wg-mover = {
    home = "/var/lib/wg-mover";
    createHome = true;
    isSystemUser = true;
    group = "wg-mover";
  };
  users.groups.wg-mover = {};

  imports = [
    ./jellyseer.nix
  ];

  nixarr = {
    enable = true;
    # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/mnt/library/media";
    stateDir = "/data/media/.state/nixarr";

    vpn = {
      enable = true;
      # WARNING: This file must _not_ be in the config git directory
      wgConf = "var/lib/wg-mover/wg.conf";
    };

    jellyfin = {
      enable = true;
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 24090; # Set this to the port forwarded by your VPN
    };

    sabnzbd = {
      enable = true;
      vpn.enable = true;
    };

    # It is possible for this module to run the *Arrs through a VPN, but it
    # is generally not recommended, as it can cause rate-limiting issues.
    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
  };
}
