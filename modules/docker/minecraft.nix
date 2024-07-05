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
  virtualisation.oci-containers.containers."minecraft-mc" = {
    image = "itzg/minecraft-server";
    environment = {
      EULA = "true";
      DIFFICULTY = "hard";
    };
    volumes = [
      "data:/data:rw"
    ];
    ports = [
      "25565:25565/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mc"
      "--network=minecraft_default"
    ];
  };
  systemd.services."docker-minecraft-mc" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-minecraft_default.service"
      "docker-volume-minecraft_data.service"
    ];
    requires = [
      "docker-network-minecraft_default.service"
      "docker-volume-minecraft_data.service"
    ];
    partOf = [
      "docker-compose-minecraft-root.target"
    ];
    wantedBy = [
      "docker-compose-minecraft-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-minecraft_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f minecraft_default";
    };
    script = ''
      docker network inspect minecraft_default || docker network create minecraft_default
    '';
    partOf = ["docker-compose-minecraft-root.target"];
    wantedBy = ["docker-compose-minecraft-root.target"];
  };

  # Volumes
  systemd.services."docker-volume-minecraft_data" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect minecraft_data || docker volume create minecraft_data
    '';
    partOf = ["docker-compose-minecraft-root.target"];
    wantedBy = ["docker-compose-minecraft-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-minecraft-root" = {
    wantedBy = ["multi-user.target"];
  };
}
