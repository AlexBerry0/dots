{pkgs, ...}: {
  programs.vscode = {
    enable = true;

    profiles = {
      default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = with pkgs.vscode-extensions;
          [
            catppuccin.catppuccin-vsc
            pkief.material-icon-theme
            bbenoist.nix
            kamadorueda.alejandra
            esbenp.prettier-vscode
            dbaeumer.vscode-eslint
            svelte.svelte-vscode
            astro-build.astro-vscode
            ms-python.python
            ms-python.black-formatter
            ms-python.debugpy
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            ms-vscode.cpptools
            ms-toolsai.jupyter
            ms-toolsai.jupyter-keymap
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
            timonwong.shellcheck
            foxundermoon.shell-format
            mkhl.direnv
            streetsidesoftware.code-spell-checker
            editorconfig.editorconfig
            mechatroner.rainbow-csv
            shardulm94.trailing-spaces
            christian-kohler.path-intellisense
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
          "window.autoDetectColorScheme" = true;
          "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
          "workbench.preferredLightColorTheme" = "Solarized Light";
          "workbench.iconTheme" = "material-icon-theme";

          "editor.fontFamily" = "'Hack Nerd Font', 'HackNerdFont', monospace";
          "editor.formatOnType" = true;
          "editor.formatOnSave" = true;
          "editor.inlineSuggest.enabled" = false;
          "cSpell.language" = "en-GB";
          "workbench.startupEditor" = "none";
          "workbench.editor.centeredLayout" = false;

          "zenMode.fullScreen" = false;
          "zenMode.centerLayout" = false;
          "zenMode.hideActivityBar" = true;
          "zenMode.hideStatusBar" = true;
          "zenMode.hideLineNumbers" = false;
          "zenMode.showTabs" = "none";

          "[nix]"."editor.defaultFormatter" = "kamadorueda.alejandra";
          "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
          "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
          "[c]"."editor.defaultFormatter" = "ms-vscode.cpptools";
          "[cpp]"."editor.defaultFormatter" = "ms-vscode.cpptools";
          "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[html]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[css]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[json]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
          "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
          "[astro]"."editor.defaultFormatter" = "esbenp.prettier-vscode";

          "security.workspace.trust.untrustedFiles" = "open";
          "github.copilot.enable" = {
            "*" = true;
          };
        };
      };

      "Typst" = {
        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          pkief.material-icon-theme
          tomoki1207.pdf
          myriad-dreamin.tinymist
          streetsidesoftware.code-spell-checker
          vscodevim.vim
        ];

        userSettings = {
          "window.autoDetectColorScheme" = true;
          "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
          "workbench.preferredLightColorTheme" = "Solarized Light";
          "workbench.iconTheme" = "material-icon-theme";

          "editor.wordWrap" = "on";
          "editor.minimap.enabled" = false;
          "editor.formatOnType" = true;
          "editor.formatOnSave" = true;
          "editor.lineNumbers" = "relative";
          "cSpell.language" = "en-GB";

          "[typst]" = {
            "editor.defaultFormatter" = "myriad-dreamin.tinymist";
          };
          "tinymist.formatterMode" = "typstyle";
          "tinymist.exportPdf" = "onType";
          "tinymist.outputPath" = "$root/pdf_outputs/$dir/$name";

          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "workbench.statusBar.visible" = false;
        };

        keybindings = [
          {
            key = "ctrl+alt+m";
            command = "workbench.action.toggleZenMode";
          }
        ];
      };

      devops = {
        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
          pkief.material-icon-theme
          ms-azuretools.vscode-docker
          ms-kubernetes-tools.vscode-kubernetes-tools
          redhat.vscode-yaml
          hashicorp.terraform
          mkhl.direnv
          timonwong.shellcheck
          foxundermoon.shell-format
          editorconfig.editorconfig
          streetsidesoftware.code-spell-checker
          shardulm94.trailing-spaces
        ];

        userSettings = {
          "window.autoDetectColorScheme" = true;
          "workbench.preferredDarkColorTheme" = "Catppuccin Mocha";
          "workbench.preferredLightColorTheme" = "Solarized Light";
          "workbench.iconTheme" = "material-icon-theme";

          "editor.fontFamily" = "'Hack Nerd Font', 'HackNerdFont', monospace";
          "editor.formatOnSave" = true;
          "editor.formatOnType" = true;
          "cSpell.language" = "en-GB";

          "[yaml]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[dockerfile]" = {
            "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
          };
          "[terraform]" = {
            "editor.defaultFormatter" = "hashicorp.terraform";
          };

          "docker.showStartPage" = false;
          "vs-kubernetes" = {
            "vs-kubernetes.crd-code-completion" = "enabled";
          };
        };
      };
    };
  };
}
