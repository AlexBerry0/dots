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
    "text/x-typst"
  ];
in {
  catppuccin.vscode.profiles.default.enable = false;
  catppuccin.vscode.profiles.typst.enable = false;

  xdg.mimeApps.defaultApplications = builtins.listToAttrs (map (mimeType: {
      name = mimeType;
      value = ["code.desktop"];
    })
    mimeTypes);

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions;
        [
          yzhang.markdown-all-in-one
          brettm12345.nixfmt-vscode
          mikestead.dotenv
          ms-toolsai.jupyter
          ms-toolsai.jupyter-renderers
          ms-toolsai.jupyter-keymap
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          ms-python.python
          svelte.svelte-vscode
          bbenoist.nix
          christian-kohler.path-intellisense
          dbaeumer.vscode-eslint
          editorconfig.editorconfig
          esbenp.prettier-vscode
          foxundermoon.shell-format
          kamadorueda.alejandra
          shardulm94.trailing-spaces
          timonwong.shellcheck
          astro-build.astro-vscode
          ms-python.black-formatter
          streetsidesoftware.code-spell-checker
          mkhl.direnv
          signageos.signageos-vscode-sops
          editorconfig.editorconfig
          mechatroner.rainbow-csv
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
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
          {
            name = "code-spell-checker-british-english";
            publisher = "streetsidesoftware";
            version = "1.3.0";
            sha256 = "sha256-w6RNWJH8Orc3dM0iH0sFh+WdvYTThn74HJ89KTPNAUA=";
          }
        ];

      userSettings = {
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
        "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
        "security.workspace.trust.untrustedFiles" = "open";
        "github.copilot.enable" = {
          "*" = true;
        };
        "zenMode.fullScreen" = false;
        "zenMode.centerLayout" = false;
        "zenMode.hideActivityBar" = true;
        "zenMode.hideStatusBar" = true;
        "zenMode.hideLineNumbers" = false;
        "zenMode.showTabs" = "none";
        "editor.inlineSuggest.enabled" = false;
        "editor.formatOnType" = true;
        "cSpell.language" = "en,en-GB";
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.startupEditor" = "none";
        "terminal.integrated.fontFamily" = "'Hack Nerd Font', 'HackNerdFont', monospace";
        "workbench.editor.centeredLayout" = false;
      };
    };

    profiles.typst = {
      extensions = with pkgs.vscode-extensions;
        [
          myriad-dreamin.tinymist
          tomoki1207.pdf
          streetsidesoftware.code-spell-checker
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "code-spell-checker-british-english";
            publisher = "streetsidesoftware";
            version = "1.3.0";
            sha256 = "sha256-w6RNWJH8Orc3dM0iH0sFh+WdvYTThn74HJ89KTPNAUA=";
          }
        ];
      userSettings = {
        "editor.wordWrap" = "on";
        "editor.minimap.enabled" = false;
        "workbench.activityBar.visible" = true;
        "workbench.statusBar.visible" = false;
        "workbench.editor.showTabs" = "multiple";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "zenMode.fullScreen" = false;
        "zenMode.centerLayout" = false;
        "zenMode.hideActivityBar" = true;
        "zenMode.hideStatusBar" = true;
        "zenMode.hideLineNumbers" = false;
        "zenMode.showTabs" = "none";
        "editor.inlineSuggest.enabled" = false;
        "editor.formatOnType" = true;
        "cSpell.language" = "en,en-GB";
        "[typst]" = {
          "editor.defaultFormatter" = "myriad-dreamin.tinymist";
          "editor.formatOnSave" = true;
        };
        "tinymist.formatterMode" = "typstyle";
        "tinymist.exportPdf" = "onType";
        "tinymist.outputPath" = "$root/pdf_outputs/$dir/$name";
        "workbench.editor.centeredLayout" = false;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
      };
      keybindings = [
        {
          key = "ctrl+alt+m";
          command = "workbench.action.toggleZenMode";
        }
      ];
    };

    mutableExtensionsDir = false;
  };
}
