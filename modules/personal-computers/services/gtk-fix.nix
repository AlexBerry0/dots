{
  pkgs,
  inputs,
  config,
  ...
}: {
  # On home manager rebuild sometimes there will be a GTK theme file conflict, this service hotfixes that
  systemd.services."gtk-fix" = {
    script = ''
      rm /home/alexb/.config/gtk-4.0/gtk.css
    '';
    serviceConfig = {
      User = "gtk-fix";
      Type = "oneshot";
    };
    wantedBy = ["multi-user.target"];
  };

  users.users.gtk-fix = {
    home = "/var/lib/gtk-fix";
    createHome = true;
    isSystemUser = true;
    group = "gtk-fix";
  };
  users.groups.gtk-fix = {};
}
