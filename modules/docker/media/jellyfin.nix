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
  virtualisation.oci-containers.containers."jellyfin" = {
    image = "jellyfin/jellyfin";
    volumes = [
      "/root/home/user/docker/jellyfin/cache/:/cache:rw"
      "/root/home/user/docker/jellyfin/config/:/config:rw"
      "/root/home/user/media:/media:rw"
      "/root/home/user/media:/media2:ro"
    ];
    ports = ["8096:8096"];
    user = "uid:gid";
    log-driver = "journald";
    extraOptions = [
      "--network=host"
    ];
  };
  systemd.services."docker-jellyfin" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    partOf = [
      "docker-compose-jellyfin-root.target"
    ];
    wantedBy = [
      "docker-compose-jellyfin-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-jellyfin-root" = {
    unitConfig = {
    };
    wantedBy = ["multi-user.target"];
  };
}
