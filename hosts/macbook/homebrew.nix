{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
    };

    taps = [
      "marek-vybiral/macos-wp"
    ];

    brews = [
      "marek-vybiral/macos-wp/macos-wp"
      "evtx"
      "spicetify-cli"
    ];

    casks = [
      "zen"
      "beeper"
      "spotify"
      "discord"
      "bitwarden"
      "pocket-casts"
      "ghostty"
      "utm"

      # Previously installed by hand from .dmg files. On the first switch after
      # adding these, run `brew install --cask --adopt <name>` (or --force for a
      # version mismatch) so Homebrew takes over the existing app.
      "google-chrome"
      "whatsapp"
      "steam"
      "blender"
      "chatgpt"
      "claude"
      "antigravity"
      "prismlauncher"
      "roblox"
      "qbittorrent"
      "alcove"
      "onedrive"
    ];
  };
}
