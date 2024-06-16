{
  inputs,
  pkgs,
  ...
}: let
  Catppuccin-Mocha = import ../../pkgs/modded-catppuccin.nix {inherit pkgs;};
in {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Reversal-purple-dark";
      package = pkgs.reversal-icon-theme.override {
        colorVariants = ["-purple"];
      };
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

  # home.file.".themes/Catppuccin-Mocha" = {
  #   source = "${modded-catppuccin}/Catppuccin-Mocha";
  #   recursive = true;
  # };

  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha";
}
