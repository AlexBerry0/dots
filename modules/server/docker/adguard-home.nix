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
  virtualisation.oci-containers.containers."adguardhome" = {
    image = "adguard/adguardhome";
    volumes = [
      "/home/user/docker/adguard-home/config/:/opt/adguardhome/conf:rw"
      "/home/user/docker/adguard-home/work/:/opt/adguardhome/work:rw"
    ];
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "67:67/udp"
      "80:80/tcp"
      "443:443/tcp"
      "443:443/udp"
      "3000:3000/tcp"
      "853:853/tcp"
      "784:784/udp"
      "853:853/udp"
      "8853:8853/udp"
      "5443:5443/tcp"
      "5443:5443/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=adguardhome"
      "--network=adguard-home_default"
    ];
  };
  systemd.services."docker-adguardhome" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-adguard-home_default.service"
    ];
    requires = [
      "docker-network-adguard-home_default.service"
    ];
    partOf = [
      "docker-compose-adguard-home-root.target"
    ];
    wantedBy = [
      "docker-compose-adguard-home-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-adguard-home_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f adguard-home_default";
    };
    script = ''
      docker network inspect adguard-home_default || docker network create adguard-home_default
    '';
    partOf = ["docker-compose-adguard-home-root.target"];
    wantedBy = ["docker-compose-adguard-home-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-adguard-home-root" = {
    unitConfig = {
    };
    wantedBy = ["multi-user.target"];
  };
}
