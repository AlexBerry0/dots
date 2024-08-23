{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    oh-my-posh
    zoxide
  ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      palette = "catppuccin_mocha";

      format = "[](fg:blue)$directory$character";

      right_format = "[](fg:yellow)$cmd_duration[](fg:sky bg:yellow)$aws$conda$dart$docker_context$elixir$elm$gcloud$golang$hg_branch$java$julia$nim$nodejs$perl$php$python$ruby$rust$scala$shlvl$swift$terraform[](fg:peach bg:sky)$git_branch$git_status[](bg:peach fg:teal)$kubernetes[](fg:teal)";

      add_newline = false;

      "line_break" = {
        disabled = false;
      };

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

      "cmd_duration" = {
        style = "bg:yellow fg:base";
        format = "[ $duration ]($style)";
      };

      # hostname = {
      #   style = "bg:sky fg:base";
      #   format = "[ $hostname ]($style)";
      # };

      "git_branch" = {
        symbol = "";
        style = "bg:peach fg:base";
        format = "[ $symbol $branch ]($style)";
      };

      "git_status" = {
        style = "bg:peach fg:base";
        format = "[$all_status$ahead_behind ]($style)";
      };

      kubernetes = {
        disabled = false;
        format = "[ $symbol$context ]($style)";
        style = "bg:teal fg:base";
      };
      aws = {
        symbol = "  ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      conda = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      dart = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      docker_context = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      elixir = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      elm = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      gcloud = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      golang = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      hg_branch = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      java = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      julia = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      nim = {
        symbol = "󰆥 ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      nodejs = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      # package = {
      #   symbol = "󰏗 ";
      #   format = "[ $symbol ]($style)";
      #   style = "bg:sky fg:base";
      # };
      perl = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      php = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      python = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      ruby = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      rust = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      scala = {
        symbol = " ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      shlvl = {
        symbol = "";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      swift = {
        symbol = "󰛥 ";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
      };
      terraform = {
        symbol = "󱁢";
        format = "[ $symbol ]($style)";
        style = "bg:sky fg:base";
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

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting

      nitch

      # Get rid of the `l` alias
      functions --erase l

      # Use terminal colours for fzf
      set -Ux FZF_DEFAULT_OPTS "--color 16"

      # Initialise some stuff
      starship init fish | source
      zoxide init fish --cmd cd | source
    '';

    functions = {
      # The `take` function from oh my zsh
      take = ''
        # Do nothing if no args were passed
        if test (count $argv) = 0
        	echo Please provide at laest one argument.
        	return 1
        end

        if test (string sub -s -4 $argv[1]) = ".git" # If the first arg ends with .git
        	# If more than two args were passed, error and exit
        	if test (count $argv) -gt 2
        		echo Error: too many arguments. Expected one or two.
        		return 1
        	end

        	git clone $argv[1] $argv[2] # Clone the repo (optionally into a specific folder)

        	if test (count $argv) = 1  # If a second argument wasn't passed
        		set folder_name (string match -r '(?<=/)[^/]+(?=.git$)' $argv[1]) # Use the name of the repo as the folder name
        	else
        		set folder_name $argv[2] # Otherwise, use the specified one
        	end

        	cd $folder_name
        else
        	if test (count $argv) -gt 1
        		echo Error: too many arguments. Only expected one.
        		return 1
        	end
        		mkdir -p $argv[1]
        		cd $argv[1]
        end
      '';
    };
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];
    shellAliases = {
      ll = "ls -l";
      kssh = "kitty +kitten ssh";
      update = "cd /etc/nixos && sudo nix flake update && cd";
      rebuild = "nh os switch -H desktop";
      pull = "git pull";
      push = "git push";
      commit = "git add --all && git commit";
    };
  };
}
