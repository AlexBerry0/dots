{ ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      palette = "catppuccin_mocha";
      format = "[](fg:blue)$directory$character";
      right_format = "[](fg:yellow)$cmd_duration[](fg:sky bg:yellow)$aws$conda$dart$docker_context$elixir$elm$gcloud$golang$hg_branch$java$julia$nim$nodejs$perl$php$python$ruby$rust$scala$shlvl$swift$terraform[](fg:peach bg:sky)$git_branch$git_status[](bg:peach fg:teal)$kubernetes[](fg:teal)";
      add_newline = false;

      line_break.disabled = false;

      directory = {
        style = "bg:blue fg:base";
        format = "[ $path ]($style)";
        truncation_length = 2;
        truncation_symbol = "…/";
        fish_style_pwd_dir_length = 2;
      };

      character = {
        success_symbol = "[](bg:green fg:blue)[](fg:green)";
        error_symbol = "[](bg:red fg:blue)[](fg:red)";
        vimcmd_symbol = "[](fg:yellow bg:blue)[](bg:yellow fg:base)";
        vimcmd_replace_one_symbol = "[](fg:flamingo bg:blue)[](bg:flamingo fg:base)";
        vimcmd_replace_symbol = "[](fg:flamingo bg:blue)[](bg:flamingo fg:base)";
        vimcmd_visual_symbol = "[](fg:yellow bg:blue)[](bg:yellow fg:base)";
      };

      cmd_duration = {
        style = "bg:yellow fg:base";
        format = "[ $duration ]($style)";
      };

      git_branch = {
        symbol = "";
        style = "bg:peach fg:base";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:peach fg:base";
        format = "[$all_status$ahead_behind ]($style)";
      };

      kubernetes = {
        disabled = false;
        format = "[ $symbol$context ]($style)";
        style = "bg:teal fg:base";
      };

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    };
  };
}
