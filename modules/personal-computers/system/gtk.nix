{
  inputs,
  pkgs,
  config,
  ...
}: let
  modded-catppuccin = pkgs.fetchFromGitHub {
    owner = "AlexBerry0";
    repo = "Modded-Catppuccin-Mocha-GTK-theme";
    rev = "5ec4a99d456047dfe94d5724ab137f6de21abdc6";
    hash = "sha256-Ke4+jzxObBUejdmaAte2KOdBudbQ1jIyQ1Kb3kvFK9c=";
  };
in {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Reversal-purple-dark";
      package = pkgs.reversal-icon-theme.overrideAttrs (oldAttrs: {
        installPhase = ''
          mkdir -p $out/share/icons
          ./install.sh -d $out/share/icons -n Reversal -t all
        '';
      });
    };

    theme = {
      name = "Catppuccin-Mocha";
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 22;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.file.".themes/Catppuccin-Mocha" = {
    source = "${modded-catppuccin}/Catppuccin-Mocha";
    recursive = true;
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${modded-catppuccin}/Catppuccin-Mocha/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${modded-catppuccin}/Catppuccin-Mocha/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${modded-catppuccin}/Catppuccin-Mocha/gtk-4.0/gtk-dark.css";
  };

  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha";
}
