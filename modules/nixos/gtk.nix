{
  inputs,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    iconTheme = {
      name = "Reversal-purple-dark";
      package = pkgs.reversal-icon-theme.override {
        colorVariants = ["-purple"];
      };
    };

    theme = {
      # name = "Catppuccin-Mocha-Standard-Peach-Dark";
      # package = pkgs.catppuccin-gtk.override {
      #   accents = ["peach"];
      #   size = "standard";
      #   variant = "mocha";
      # };
      name = "Catppuccin-Mocha";
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      # size = 16;
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

  home.sessionVariables.GTK_THEME = "Catppuccin-Mocha";
  # ...
}
