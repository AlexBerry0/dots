{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    shellInit = ''
      # Ensure Homebrew and local user binaries are on PATH
      if test -d /opt/homebrew/bin
        eval (/opt/homebrew/bin/brew shellenv)
      end
      fish_add_path --path "$HOME/.local/bin"
    '';

    interactiveShellInit = ''
      set -g fish_greeting

      # Fastfetch display
      command -v fastfetch >/dev/null && fastfetch

      set -Ux FZF_DEFAULT_OPTS "--color 16"

      # Opam initialisation if present
      if test -r "$HOME/.opam/opam-init/init.fish"
        source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null
      end
    '';

    shellAliases = {
      ll = "ls -l";
      kssh = "kitty +kitten ssh";
      pull = "git pull";
      push = "git push";
      commit = "git add --all && git commit";
    };

    functions = {
      take = ''
        if test (count $argv) = 0
          echo "Please provide at least one argument."
          return 1
        end

        if test (string sub -s -4 $argv[1]) = ".git"
          if test (count $argv) -gt 2
            echo "Error: too many arguments. Expected one or two."
            return 1
          end

          git clone $argv[1] $argv[2]
          if test (count $argv) = 1
            set folder_name (string match -r '(?<=/)[^/]+(?=.git$)' $argv[1])
          else
            set folder_name $argv[2]
          end
          cd $folder_name
        else
          if test (count $argv) -gt 1
            echo "Error: too many arguments. Only expected one."
            return 1
          end
          mkdir -p $argv[1]
          cd $argv[1]
        end
      '';
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
