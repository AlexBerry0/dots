# modules/home/vscode.nix
{pkgs, ...}: let
  tokenColorCustomizations = {
    "[Catppuccin Mocha]" = {
      textMateRules = [
        {
          scope = [
            "variable.other.readwrite.shell"
            "variable.other.readwrite.assignment.shell"
            "variable.other.assignment.shell"
            "variable.other.normal.shell"
            "variable.other.bracket.shell"
            "variable.other.shell"
          ];
          settings = {
            foreground = "#FAB387";
          };
        }
        {
          scope = [
            "variable.other.positional.shell"
            "variable.other.special.shell"
            "variable.parameter.positional.shell"
            "variable.language.special.shell"
          ];
          settings = {
            foreground = "#EBA0AC";
          };
        }
        {
          scope = [
            "punctuation.definition.variable.shell"
            "string.interpolated.dollar.shell"
          ];
          settings = {
            foreground = "#F5C2E7";
          };
        }
        {
          scope = [
            "support.function.builtin.shell"
            "support.function.builtin.sh"
          ];
          settings = {
            foreground = "#CBA6F7";
            fontStyle = "italic";
          };
        }
        {
          scope = [
            "entity.name.command.shell"
            "meta.command.name.shell"
            "support.function.shell"
          ];
          settings = {
            foreground = "#89DCEB";
          };
        }
        {
          scope = [
            "constant.other.option.shell"
            "support.command.argument.shell"
          ];
          settings = {
            foreground = "#94E2D5";
          };
        }
        {
          scope = [
            "keyword.operator.logical.shell"
            "keyword.operator.pipe.shell"
            "keyword.operator.redirect.shell"
            "keyword.operator.assignment.shell"
          ];
          settings = {
            foreground = "#74C7EC";
          };
        }
        {
          scope = [
            "keyword.control.shell"
          ];
          settings = {
            foreground = "#CBA6F7";
          };
        }
        {
          scope = [
            "entity.name.function.shell"
          ];
          settings = {
            foreground = "#89B4FA";
            fontStyle = "bold";
          };
        }
      ];
    };
    "[Solarized Light]" = {
      textMateRules = [
        {
          scope = [
            "variable.other.readwrite.shell"
            "variable.other.readwrite.assignment.shell"
            "variable.other.assignment.shell"
            "variable.other.normal.shell"
            "variable.other.bracket.shell"
            "variable.other.shell"
          ];
          settings = {
            foreground = "#6C71C4";
          };
        }
        {
          scope = [
            "variable.other.positional.shell"
            "variable.other.special.shell"
            "variable.parameter.positional.shell"
            "variable.language.special.shell"
          ];
          settings = {
            foreground = "#CB4B16";
          };
        }
        {
          scope = [
            "punctuation.definition.variable.shell"
            "string.interpolated.dollar.shell"
          ];
          settings = {
            foreground = "#D33682";
          };
        }
        {
          scope = [
            "support.function.builtin.shell"
            "support.function.builtin.sh"
          ];
          settings = {
            foreground = "#859900";
            fontStyle = "italic";
          };
        }
        {
          scope = [
            "entity.name.command.shell"
            "meta.command.name.shell"
            "support.function.shell"
          ];
          settings = {
            foreground = "#268BD2";
          };
        }
        {
          scope = [
            "constant.other.option.shell"
            "support.command.argument.shell"
          ];
          settings = {
            foreground = "#B58900";
          };
        }
        {
          scope = [
            "keyword.operator.logical.shell"
            "keyword.operator.pipe.shell"
            "keyword.operator.redirect.shell"
            "keyword.operator.assignment.shell"
          ];
          settings = {
            foreground = "#2AA198";
          };
        }
        {
          scope = [
            "keyword.control.shell"
          ];
          settings = {
            foreground = "#859900";
          };
        }
        {
          scope = [
            "entity.name.function.shell"
          ];
          settings = {
            foreground = "#268BD2";
            fontStyle = "bold";
          };
        }
      ];
    };
  };
in {
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
          "editor.semanticHighlighting.enabled" = true;
          "editor.tokenColorCustomizations" = tokenColorCustomizations;
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
          "[shellscript]"."editor.defaultFormatter" = "foxundermoon.shell-format";

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
          "editor.semanticHighlighting.enabled" = true;
          "editor.tokenColorCustomizations" = tokenColorCustomizations;
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
          "[shellscript]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
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
