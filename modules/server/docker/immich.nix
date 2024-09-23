{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."immich_machine_learning" = {
    image = "ghcr.io/immich-app/immich-machine-learning:release";
    volumes = [
      "immich_model-cache:/cache:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich-machine-learning"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_machine_learning" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
      User = "immich";
    };
    after = [
      "docker-network-immich_default.service"
      "docker-volume-immich_model-cache.service"
    ];
    requires = [
      "docker-network-immich_default.service"
      "docker-volume-immich_model-cache.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };
  virtualisation.oci-containers.containers."immich_postgres" = {
    image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
    environment = {
      POSTGRES_DB = "${config.sops.secrets."immich/DB_DATABASE_NAME".path}";
      POSTGRES_INITDB_ARGS = "--data-checksums";
      POSTGRES_PASSWORD = "${config.sops.secrets."immich/DB_PASSWORD".path}";
      POSTGRES_USER = "${config.sops.secrets."immich/DB_USERNAME".path}";
    };
    volumes = [
      "/mnt/drive2/immich/postgres:/var/lib/postgresql/data:rw"
    ];
    cmd = ["postgres" "-c" "shared_preload_libraries=vectors.so" "-c" "search_path=\"$user\", public, vectors" "-c" "logging_collector=on" "-c" "max_wal_size=2GB" "-c" "shared_buffers=512MB" "-c" "wal_compression=on"];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=pg_isready --dbname='${config.sops.secrets."immich/DB_DATABASE_NAME".path}' --username='${config.sops.secrets."immich/DB_USERNAME".path}' || exit 1; Chksum=\"$(psql --dbname='${config.sops.secrets."immich/DB_DATABASE_NAME".path}' --username='${config.sops.secrets."immich/DB_USERNAME".path}' --tuples-only --no-align --command='SELECT COALESCE(SUM(checksum_failures), 0) FROM pg_stat_database')\"; echo \"checksum failure count is $Chksum\"; [ \"$Chksum\" = '0' ] || exit 1"
      "--health-interval=5m0s"
      "--health-start-period=5m0s"
      "--network-alias=database"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
      User = "immich";
    };
    after = [
      "docker-network-immich_default.service"
    ];
    requires = [
      "docker-network-immich_default.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };
  virtualisation.oci-containers.containers."immich_redis" = {
    image = "docker.io/redis:6.2-alpine@sha256:328fe6a5822256d065debb36617a8169dbfbd77b797c525288e465f56c1d392b";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=redis-cli ping || exit 1"
      "--network-alias=redis"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
      User = "immich";
    };
    after = [
      "docker-network-immich_default.service"
    ];
    requires = [
      "docker-network-immich_default.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };
  virtualisation.oci-containers.containers."immich_server" = {
    image = "ghcr.io/immich-app/immich-server:release";
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/mnt/drive2/immich/library/media:/usr/src/app/upload:rw"
    ];
    ports = [
      "2283:3001/tcp"
    ];
    dependsOn = [
      "immich_postgres"
      "immich_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich-server"
      "--network=immich_default"
    ];
  };
  systemd.services."docker-immich_server" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
      User = "immich";
    };
    after = [
      "docker-network-immich_default.service"
    ];
    requires = [
      "docker-network-immich_default.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-immich_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f immich_default";
      User = "immich";
    };
    script = ''
      docker network inspect immich_default || docker network create immich_default
    '';
    partOf = ["docker-compose-immich-root.target"];
    wantedBy = ["docker-compose-immich-root.target"];
  };

  # Volumes
  systemd.services."docker-volume-immich_model-cache" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "immich";
    };
    script = ''
      docker volume inspect immich_model-cache || docker volume create immich_model-cache
    '';
    partOf = ["docker-compose-immich-root.target"];
    wantedBy = ["docker-compose-immich-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-immich-root" = {
    wantedBy = ["multi-user.target"];
  };

  users.users.immich = {
    home = "/var/lib/immich";
    createHome = true;
    isSystemUser = true;
    group = "immich";
  };
  users.groups.immich = {};
}
