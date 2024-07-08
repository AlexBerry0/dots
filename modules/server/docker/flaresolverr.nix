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
  virtualisation.oci-containers.containers."flaresolverr" = {
    image = "flaresolverr/flaresolverr:latest";
    environment = {
      CAPTCHA_SOLVER = "none";
      LOG_HTML = "false";
      LOG_LEVEL = "info";
    };
    ports = [
      "8191:8191/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=flaresolverr"
      "--network=flaresolverr_default"
    ];
  };
  systemd.services."docker-flaresolverr" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-flaresolverr_default.service"
    ];
    requires = [
      "docker-network-flaresolverr_default.service"
    ];
    partOf = [
      "docker-compose-flaresolverr-root.target"
    ];
    wantedBy = [
      "docker-compose-flaresolverr-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-flaresolverr_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.docker}/bin/docker network rm -f flaresolverr_default";
    };
    script = ''
      docker network inspect flaresolverr_default || docker network create flaresolverr_default
    '';
    partOf = ["docker-compose-flaresolverr-root.target"];
    wantedBy = ["docker-compose-flaresolverr-root.target"];
  };

  # Root service
  systemd.targets."docker-compose-flaresolverr-root" = {
    wantedBy = ["multi-user.target"];
  };
}
