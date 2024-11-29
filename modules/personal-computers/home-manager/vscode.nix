{
  config,
  pkgs,
  ...
}: let
  mimeTypes = [
    "application/javascript"
    "application/sql"
    "application/toml"
    "application/x-shellscript"
    "application/yaml"
    "text/css"
    "text/english"
    "text/html"
    "text/javascript"
    "text/markdown"
    "text/plain"
    "text/rust"
    "text/x-c"
    "text/x-c++"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-cmake"
    "text/x-csrc"
    "text/x-go"
    "text/x-lua"
    "text/x-makefile"
    "text/x-python"
    "text/x-scss"
    "text/x-ocaml"
  ];
in {
  xdg.mimeApps.defaultApplications = builtins.listToAttrs (map (mimeType: {
      name = mimeType;
      value = ["code.desktop"];
    })
    mimeTypes);

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions;
      [
        # Looks
        catppuccin.catppuccin-vsc-icons
        catppuccin.catppuccin-vsc

        # Languages
        yzhang.markdown-all-in-one
        brettm12345.nixfmt-vscode
        mikestead.dotenv
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-python.python
        ocamllabs.ocaml-platform
        svelte.svelte-vscode

        # Copilot
        github.copilot
        github.copilot-chat

        # Formatters
        bbenoist.nix
        christian-kohler.path-intellisense
        dbaeumer.vscode-eslint
        editorconfig.editorconfig
        esbenp.prettier-vscode
        foxundermoon.shell-format
        kamadorueda.alejandra
        shardulm94.trailing-spaces
        timonwong.shellcheck
        hashicorp.terraform
        astro-build.astro-vscode
        badochov.ocaml-formatter

        # Other
        streetsidesoftware.code-spell-checker
        mkhl.direnv
        signageos.signageos-vscode-sops
        editorconfig.editorconfig
        gruntfuggly.todo-tree
        ms-vscode-remote.remote-containers
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ecdc";
          publisher = "mitchdenny";
          version = "1.8.0";
          sha256 = "sha256-W2WlngFC5pAAjkj4lQNR5yPJZiedkjqGZHldjx8m7IU=";
        }
        {
          name = "vscode-toggle-quotes";
          publisher = "britesnow";
          version = "0.3.6";
          sha256 = "sha256-Hn3Mk224ePAAnNtkhKMcCil/kTgbonweb1i884Q62rs=";
        }
        {
          name = "markdown-table-formatter";
          publisher = "fcrespo82";
          version = "3.0.0";
          sha256 = "sha256-rUxKfr6mAyHzRtbbozZGYJ8itky3gICSnvnvb3b3PYU=";
        }
      ];

    userSettings = {
      # Define formatters for different languges
      "[c]"."editor.defaultFormatter" = "xaver.clang-format";
      "[cpp]"."editor.defaultFormatter" = "xaver.clang-format";
      "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[less]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[nix]"."editor.defaultFormatter" = "kamadorueda.alejandra";
      "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
      "[scss]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[astro]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[ocaml]"."editor.defaultFormatter" = "badochov.ocaml-formatter";
      "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";

      "security.workspace.trust.untrustedFiles" = "open";
      "github.copilot.enable" = {
        "*" = true;
      };
      "editor.inlineSuggest.enabled" = false;
      "editor.formatOnType" = true;
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.colorTheme" = "Catppuccin Mocha";
    };
  };
}
