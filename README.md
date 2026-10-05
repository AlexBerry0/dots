# Alex's macOS Dotfiles

> **Historical Archive: NixOS Linux Dotfiles**
> This repository originally managed my Lenovo Yoga 6 running NixOS, GNOME, and SDDM.
> That complete setup has been archived and can be explored at:
> - Tag: https://github.com/AlexBerry0/dots/tree/nixos-final

---

## Architecture Overview

The system is split into distinct declarative layers:

- **nix-darwin:** System-level macOS defaults (Dock, Finder, Trackpad, Spaces), fonts, Touch ID PAM rules, and Nix daemon settings.
- **Home Manager:** User environment, CLI tooling, Fish shell, Starship prompt, Neovim, multi-profile VS Code, and user launchd background agents.
- **Homebrew:** Declaratively managed via nix-darwin for macOS GUI applications (casks) and specialized tools.
- **Catppuccin Mocha:** System-wide dark palette applied across terminal, editors, and prompts.

---

## Daily Management

Rebuild and activate the system configuration:
`darwin-rebuild switch --flake .#macbook`

Update flake lock dependencies:
`nix flake update`
