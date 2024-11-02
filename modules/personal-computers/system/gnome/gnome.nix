{
  inputs,
  lib,
  pkgs,
  ...
}:
# let
#   modded-unite = import ../../../../pkgs/modded-unite.nix {inherit pkgs;};
# in
{
  imports = [
    ./dconf/common-extensions.nix
    ./dconf/common-system.nix
  ];

  home.packages = [
    pkgs.gnomeExtensions.user-themes
    pkgs.gnomeExtensions.quick-settings-tweaker
    pkgs.gnomeExtensions.autohide-battery
    pkgs.gnomeExtensions.bluetooth-quick-connect
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.burn-my-windows
    pkgs.gnomeExtensions.compiz-windows-effect
    pkgs.gnomeExtensions.coverflow-alt-tab
    pkgs.gnomeExtensions.just-perfection
    pkgs.gnomeExtensions.logo-menu
    pkgs.gnomeExtensions.media-controls
    pkgs.gnomeExtensions.no-titlebar-when-maximized
    pkgs.gnomeExtensions.notification-banner-reloaded
    pkgs.gnomeExtensions.order-gnome-shell-extensions
    pkgs.gnomeExtensions.pip-on-top
    pkgs.gnomeExtensions.tiling-assistant
    pkgs.gnomeExtensions.transparent-window-moving
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.unite
    pkgs.gnomeExtensions.airpod-battery-monitor
    # modded-unite
    pkgs.catppuccin
  ];
}
