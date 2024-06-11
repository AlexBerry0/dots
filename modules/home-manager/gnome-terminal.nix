{
  pkgs,
  config,
  ...
}: {
      programs.gnome-terminal = {
        enable = true;
        profile..colors.palettewith with config.colorScheme.colors = {
          "0x${base00}"
          "0x${base0D}"
          "0x${base0C}"
          "0x${base0B}"
          "0x${base0E}"
          "0x${base08}"
          "0x${base06}"
          "0x${base0A}"
        };
      };
    }