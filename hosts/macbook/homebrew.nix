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
    ];

    casks = [
      "font-hack-nerd-font"
      "zen"
      "beeper"
      "spotify"
      "discord"
      "bitwarden"
      "pocket-casts"
      "ghostty"
    ];
  };
}
