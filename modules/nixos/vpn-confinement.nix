{
  pkgs,
  lib,
  config,
  ...
}: {
  # Define VPN network namespace
  vpnnamespaces.wg = {
    enable = true;
    wireguardConfigFile = /. + "/data/.secret/vpn/wg.conf";
    accessibleFrom = [
      "192.168.1.0/24"
    ];
    portMappings = [
      {
        from = 9091;
        to = 9091;
      }
    ];
    openVPNPorts = [
      {
        port = 60729;
        protocol = "both";
      }
    ];
  };

  # Add systemd service to VPN network namespace.
  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };

  services.transmission = {
    enable = true;
    settings = {
      "rpc-bind-address" = "0.0.0.0"; # Bind RPC/WebUI to bridge address
    };
    rpc-whitelist = "*.*.*.*";
    rpc-whitelist-enabled = 1;
  };
}
