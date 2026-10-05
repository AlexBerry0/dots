{...}: {
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 63;
      mru-spaces = false;
      persistent-apps = [
        "/Applications/Zen.app"
        "/Applications/Beeper Desktop.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Photos.app"
        "/Applications/Spotify.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Ghostty.app"
      ];
      wvous-br-corner = 14;
    };

    finder = {
      FXPreferredViewStyle = "icnv";
      FXRemoveOldTrashItems = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
    };

    trackpad = {
      Clicking = false;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = true;
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLanguages = ["en-NZ"];
        AppleLocale = "en_NZ";
      };
    };
  };
}
