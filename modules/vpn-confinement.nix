{
  pkgs,
  lib,
  config,
  ...
}: {
  # Define VPN network namespace
  vpnnamespaces.wg = {
    enable = true;
    wireguardConfigFile = /. + "/.secrets/vpn/wg.conf";
    accessibleFrom = [
      "192.168.0.0/24"
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
      "rpc-bind-address" = "192.168.1.224"; # Bind RPC/WebUI to bridge address
    };
  };
}