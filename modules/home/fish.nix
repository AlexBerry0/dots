{
  config,
  lib,
  settings,
  ...
}: let
  repo = lib.escapeShellArg settings.repoDir;
  target = lib.escapeShellArg "${settings.repoDir}#${settings.hostName}";
  systemTarget = lib.escapeShellArg "${settings.repoDir}#darwinConfigurations.${settings.hostName}.system";
in {
  programs.fish = {
    enable = true;

    shellInit = ''
      fish_add_path --path /run/current-system/sw/bin
      fish_add_path --path /etc/profiles/per-user/${config.home.username}/bin
      fish_add_path --path "$HOME/.nix-profile/bin"
      fish_add_path --path "$HOME/.local/bin"

      if test -d /opt/homebrew/bin
        eval (/opt/homebrew/bin/brew shellenv)
      end
    '';

    interactiveShellInit = ''
      set -g fish_greeting

      command -v fastfetch >/dev/null && fastfetch

      set -Ux FZF_DEFAULT_OPTS "--color 16"

      if test -r "$HOME/.opam/opam-init/init.fish"
        source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null
      end
    '';

    shellAliases = {
      ll = "ls -l";
      pull = "git pull";
      push = "git push";
      commit = "git add --all && git commit";
      rebuild = "sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ${target}";
      update = "nix flake update --flake ${repo}";
      build = "nix build --no-write-lock-file --out-link ${lib.escapeShellArg "${settings.repoDir}/result"} ${systemTarget}";
    };

    functions = {
      take = ''
        if test (count $argv) = 0
          echo "Usage: take <directory> or take <repository-url> [destination]"
          return 1
        end

        if string match -rq '^(https?://|ssh://|git://|[^/]+@[^:]+:)|\.git/?$' -- "$argv[1]"
          if test (count $argv) -gt 2
            echo "Expected a repository URL and an optional destination."
            return 1
          end
          set -l folder_name
          if test (count $argv) = 2
            set folder_name "$argv[2]"
          else
            set -l url (string replace -r '/+$' "" -- "$argv[1]")
            set folder_name (string replace -r '\.git$' "" -- (string replace -r '^.*[/:]' "" -- "$url"))
          end
          if test -z "$folder_name"
            echo "Could not determine a destination; provide one explicitly."
            return 1
          end
          git clone -- "$argv[1]" "$folder_name"; or return $status
          cd -- "$folder_name"
        else
          if test (count $argv) -gt 1
            echo "Expected one directory."
            return 1
          end
          mkdir -p -- "$argv[1]"; or return $status
          cd -- "$argv[1]"
        end
      '';
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = ["--cmd cd"];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
