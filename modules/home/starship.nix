{lib, ...}: let
  runtimeModules = [
    "aws"
    "conda"
    "dart"
    "docker_context"
    "elixir"
    "elm"
    "golang"
    "hg_branch"
    "java"
    "julia"
    "nim"
    "nodejs"
    "perl"
    "php"
    "python"
    "ruby"
    "rust"
    "scala"
    "shlvl"
    "swift"
    "terraform"
  ];
  runtimeStyles = builtins.listToAttrs (map (name: {
      inherit name;
      value.style = "bg:sky fg:base";
    })
    runtimeModules);
in {
  programs.fish.interactiveShellInit = lib.mkAfter ''
    # Set only the prompt's visibility flag; never load project code or credentials.
    function __dots_gcloud_context --on-variable PWD
      set -e STARSHIP_GCLOUD_CONTEXT
      set -l folder "$PWD"
      while test "$folder" != /; and test "$folder" != "$HOME"
        for marker in .gcloud-prompt .gcloud cloudbuild.yaml cloudbuild.yml cloudbuild.json firebase.json .firebaserc app.yaml
          if test -e "$folder/$marker"
            set -gx STARSHIP_GCLOUD_CONTEXT 1
            return
          end
        end
        for tf in "$folder/"*.tf "$folder/"*.tf.json "$folder/terraform/"*.tf "$folder/terraform/"*.tf.json "$folder/infra/"*.tf "$folder/infra/"*.tf.json
          if string match --quiet --regex '(provider\s+"google(-beta)?"|hashicorp/google|"google(-beta)?"\s*:)' < "$tf"
            set -gx STARSHIP_GCLOUD_CONTEXT 1
            return
          end
        end
        # Don't inherit a cloud marker from outside this repository.
        test -e "$folder/.git"; and break
        set folder (path dirname "$folder")
      end
    end
    __dots_gcloud_context

    # Starship renders conditional segments. Join adjacent RGB end/start caps
    # using both actual colours, so missing segments never leave a gap.
    if functions -q fish_right_prompt
      functions --copy fish_right_prompt __dots_starship_right_prompt
      function fish_right_prompt
        set -l rendered (__dots_starship_right_prompt $argv | string collect)
        set -l esc (printf '\e')
        set -l boundary '\x1b\[38;2;([0-9;]+)m(?:\x1b\[0m)?\x1b\[38;2;([0-9;]+)m'
        set -l joined "$esc"'[48;2;$1;38;2;$2m'
        string replace --all --regex "$boundary" "$joined" -- "$rendered"
        return 0
      end
    end
  '';

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings =
      {
        palette = "catppuccin_mocha";
        format = "[](fg:blue)$directory$character";
        # Conditional segments are joined by the Fish renderer above.
        right_format = "([](fg:yellow)$cmd_duration[](fg:yellow))([](fg:sky)$aws$conda$dart$docker_context$elixir$elm$gcloud$golang$hg_branch$java$julia$nim$nodejs$perl$php$python$ruby$rust$scala$shlvl$swift$terraform[](fg:sky))([](fg:peach)$git_branch$git_status[](fg:peach))([](fg:teal)$kubernetes[](fg:teal))";
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

        gcloud = {
          detect_env_vars = ["STARSHIP_GCLOUD_CONTEXT"];
          style = "bg:sky fg:base";
          format = "[ $symbol$account(@$domain) ]($style)";
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
      }
      // runtimeStyles;
  };
}
