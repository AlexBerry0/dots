{
  pkgs,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        title = "Terminal";

        # Position and size of the terminal when it is opened
        position = {
          x = 900;
          y = 350;
        };
        dimensions = {
          lines = 40;
          columns = 125;
        };
        padding = {
          x = 12;
          y = 12;
        };
      };

      font = {
        # nerdfonts.family = "Hack";
        size = 10.0;
      };

      # background_opacity = 0.65;

      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        #   args = [ "--init-command" "echo; neofetch; echo" ];
      };
      # Uses colours from nix colors
      colors = with config.colorScheme.palette; {
        bright = {
          black = "0x${base00}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base06}";
          yellow = "0x${base09}";
        };
        cursor = {
          cursor = "0x${base06}";
          text = "0x${base06}";
        };
        normal = {
          black = "0x${base00}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base06}";
          yellow = "0x${base0A}";
        };
        primary = {
          background = "0x${base00}";
          foreground = "0x${base06}";
        };
      };
    };
  };
}
