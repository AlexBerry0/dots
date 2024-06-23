{
  pkgs,
  lib,
  ...
}: {
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers

  # Prowlarr
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "ghcr.io/linuxserver/prowlarr:develop";
    environment = {
      TZ = "Pacific/Auckland";
    };
    volumes = [
      "/root/home/user/docker/servarr/prowlarr:/config:rw"
    ];
    ports = [
      "9696:9696/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=prowlarr"
      "--network-alias=prowlarr"
      "--network=media-collection_default"
    ];
  };
  systemd.services."docker-prowlarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-media-collection_default.service"
    ];
    requires = [
      "docker-network-media-collection_default.service"
    ];
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  # QbitTorrent

  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      PGID = "1000";
      PUID = "1000";
      TZ = "Pacific/Auckland";
      WEBUI_PORT = "8180";
    };
    volumes = [
      "/root/home/user/downloads:/downloads:rw"
      "/root/home/user/docker/servarr/qbittorrent:/config:rw"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:wireguard"
    ];
  };
  systemd.services."docker-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  # Radarr

  virtualisation.oci-containers.containers."radarr" = {
    image = "ghcr.io/linuxserver/radarr";
    environment = {
      TZ = "Pacific/Auckland";
    };
    volumes = [
      "/root/home/user/media:/media/movies:rw"
      "/root/home/user/downloads:/media/_downloads:rw"
      "/root/home/user/docker/servarr/radarr:/config:rw"
    ];
    ports = [
      "7878:7878/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=radarr"
      "--network-alias=radarr"
      "--network=media-collection_default"
    ];
  };
  systemd.services."docker-radarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-media-collection_default.service"
    ];
    requires = [
      "docker-network-media-collection_default.service"
    ];
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  # Sabnzb

  virtualisation.oci-containers.containers."sabnzb" = {
    image = "lscr.io/linuxserver/sabnzbd:latest";
    environment = {
      TZ = "Pacific/Auckland";
    };
    volumes = [
      "/root/home/user/downloads:/downloads:rw"
      "/root/home/user/docker/servarr/sabnzb:/config:rw"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:wireguard"
    ];
  };
  systemd.services."docker-sabnzb" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  # Sonarr
  virtualisation.oci-containers.containers."sonarr" = {
    image = "ghcr.io/linuxserver/sonarr";
    environment = {
      TZ = "Pacific/Auckland";
    };
    volumes = [
      "/root/home/user/media:/media/tv:rw"
      "/root/home/user/downloads:/media/_downloads:rw"
      "/root/home/user/docker/servarr/sonarr:/config:rw"
    ];
    ports = [
      "8989:8989/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=sonarr"
      "--network-alias=sonarr"
      "--network=media-collection_default"
    ];
  };
  systemd.services."docker-sonarr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-media-collection_default.service"
    ];
    requires = [
      "docker-network-media-collection_default.service"
    ];
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  # Wireguard

  virtualisation.oci-containers.containers."wireguard" = {
    image = "ghcr.io/linuxserver/wireguard";
    environment = {
      TZ = "Pacific/Auckland";
    };
    volumes = [
      "/lib/modules:/lib/modules:rw"
      "/root/home/user/docker/servarr/wireguard:/config:rw"
    ];
    ports = [
      "8180:8180/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
      "8280:8280/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_MODULE"
      "--hostname=wireguard"
      "--ip=10.0.1.100"
      "--network-alias=wireguard"
      "--network=media-collection_wireguard_net"
      "--privileged"
      "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
      "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
    ];
  };
  systemd.services."docker-wireguard" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-media-collection_wireguard_net.service"
    ];
    requires = [
      "docker-network-media-collection_wireguard_net.service"
    ];
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  virtualisation.oci-containers.containers."wireguard-ui" = {
    image = "ngoduykhanh/wireguard-ui:latest";
    environment = {
      WGUI_MANAGE_RESTART = "true";
      WGUI_MANAGE_START = "true";
      # THis service is running on my home network, I'm aware this is a really stupid idea, but for now I can't be bothered with secrets management with nixos, so this will stay.
      WGUI_PASSWORD = "passwoed";
      WGUI_USERNAME = "admin";
    };
    volumes = [
      "/root/home/user/docker/servarr/wireguard-ui/config:/etc/wireguard:rw"
      "/root/home/user/docker/servarr/wireguard-ui/db:/app/db:rw"
    ];
    dependsOn = [
      "wireguard"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--log-opt=max-size=50m"
      "--network=container:wireguard"
    ];
  };
  systemd.services."docker-wireguard-ui" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-media-collection_wireguard_net.service"
    ];
    requires = [
      "docker-network-media-collection_wireguard_net.service"
    ];
    partOf = [
      "docker-compose-media-collection-root.target"
    ];
    wantedBy = [
      "docker-compose-media-collection-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-media-collection_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f media-collection_default";
    };
    script = ''
      docker network inspect media-collection_default || docker network create media-collection_default
    '';
    partOf = ["docker-compose-media-collection-root.target"];
    wantedBy = ["docker-compose-media-collection-root.target"];
  };
  systemd.services."docker-network-media-collection_wireguard_net" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f media-collection_wireguard_net";
    };
    script = ''
      docker network inspect media-collection_wireguard_net || docker network create media-collection_wireguard_net --ipam-driver=default --subnet=10.0.1.0/24
    '';
    partOf = ["docker-compose-media-collection-root.target"];
    wantedBy = ["docker-compose-media-collection-root.target"];
  };
  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-media-collection-root" = {
    unitConfig = {
    };
    wantedBy = ["multi-user.target"];
  };
}
