# Alex's macOS Dotfiles

> **NixOS Archive:** The previous Lenovo Yoga 6 configuration is preserved at [nixos-final](https://github.com/AlexBerry0/dots/tree/nixos-final).

---

## Architecture Overview

- **nix-darwin:** macOS defaults, fonts, Touch ID, and login shell.
- **Home Manager:** Fish, Starship, Neovim, VS Code, Ghostty settings, and background agents.
- **Homebrew:** GUI applications and specialized tools.
- **Determinate Nix:** Nix installation and daemon; nix-darwin's Nix management is disabled.

Shared paths and host settings live in `settings.nix`. Target: `macbook` / `aarch64-darwin`.

---

## Daily Management

From the repository directory:

```sh
nix flake update                                              # Update dependencies
git diff -- flake.lock                                       # Review changes
nix flake check --no-write-lock-file                           # Run checks
nix build --no-write-lock-file .#darwinConfigurations.macbook.system
sudo /run/current-system/sw/bin/darwin-rebuild switch --flake .#macbook
```

Fish shortcuts: `update` updates dependencies, `build` builds, and `rebuild` activates. Format with `nix fmt`.

For unstaged new files, use `path:.` instead of `.` in flake references so Nix includes them. Keep `stateVersion` unchanged unless migrating.

---

## Editors and Terminal

VS Code profiles: **Default** for development (including Astro), **Typst** for writing, and **devops** for infrastructure. Manage extensions in `modules/home/vscode.nix`.

Ghostty replaces Kitty. SSH integration handles terminal compatibility; remote Fish settings and tools require their own setup.

---

## Background Automations

- **Nix updates:** Checks daily at 10:00, offering weekly updates with a 24-hour postpone option. Requires a clean repository and administrator approval to activate. Leaves the lockfile local; never commits or pushes. Run `nix-auto-update --test` for diagnostics.
- **Notes backup:** Runs every 30 minutes and at login. Commits all non-ignored changes on the configured notes branch and pushes its upstream. Stops if remote changes need reconciliation.

Logs: `/tmp/nix-auto-update.{out,err}` and `/tmp/notes-backup.{out,err}`. Rebuild to install automation changes.
