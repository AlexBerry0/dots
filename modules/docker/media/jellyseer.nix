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
  virtualisation.oci-containers.containers."jellyseer-jellyseerr" = {
    image = "";
    volumes = [
      "/root/home/user/docker/jellyseer/:/app/.next:rw"
    ];
    ports = [
      "5055:5055/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=jellyseerr"
      "--network=jellyseer_default"
    ];
  };
  systemd.services."docker-jellyseer-jellyseerr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "\"no\"";
    };
    after = [
      "docker-network-jellyseer_default.service"
    ];
    requires = [
      "docker-network-jellyseer_default.service"
    ];
    partOf = [
      "docker-compose-jellyseer-root.target"
    ];
    wantedBy = [
      "docker-compose-jellyseer-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-jellyseer_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f jellyseer_default";
    };
    script = ''
      docker network inspect jellyseer_default || docker network create jellyseer_default
    '';
    partOf = ["docker-compose-jellyseer-root.target"];
    wantedBy = ["docker-compose-jellyseer-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-jellyseer-root" = {
    unitConfig = {};
    wantedBy = ["multi-user.target"];
  };
}
