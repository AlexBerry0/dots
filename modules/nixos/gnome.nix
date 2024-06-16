{
  inputs,
  pkgs,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = false;
      enabled-extensions = [
        "wobbly-windows@mecheye.net"
        "compiz-windows-effect@hermes83.github.com"
        "CoverflowAltTab@palatis.blogspot.com"
        "floating-dock@nandoferreira_prof@hotmail.com"
        "dash-to-dock-toggle@kavoyaa.github.com"
        "Sur_Clock@medaip90.com"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "transparent-window-moving@noobsai.github.com"
        "tiling-assistant@leleat-on-github"
        "unlockDialogBackground@sun.wxg@gmail.com"
        "autohide-battery@sitnik.ru"
        "order-extensions@wa4557.github.com"
        "GmailMessageTray@shuming0207.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "firefox-pip@bennypowers.com"
        "widgets@aylur"
        "flypie@schneegans.github.com"
        # "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "logomenu@aryan_k"
        "quick-settings-tweaks@qwreey"
        "CustomizeClockOnLockScreen@pratap.fastmail.fm"
        "ControlBlurEffectOnLockScreen@pratap.fastmail.fm"
        "Hide_Activities@shay.shayel.org"
        "blur-my-shell@aunetx"
        "unite@hardpixel.eu"
        "color-picker@tuberry"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "mediacontrols@cliffniff.github.com"
        "no-titlebar-when-maximized@alec.ninja"
        "notification-banner-reloaded@marcinjakubowski.github.com"
        "pip-on-top@rafostar.github.com"
        "x11gestures@joseexposito.github.io"
        "burn-my-windows@schneegans.github.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "google-chrome.desktop"
        "beeper.desktop"
      ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "99.9";
    };

    "org/gnome/desktop/wm/preferences" = {
      auto-raise = false;
      button-layout = "close,minimize,maximize:";
      focus-mode = "click";
      num-workspaces = 1;
      resize-with-right-button = false;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = false;
      overlay-key = "Super_L";
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file:///etc/nixos/media/space_saturn.png";
      # picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    };

    "org/gnome/shell/extensions/Logo-menu" = {
      hide-softwarecentre = true;
      menu-button-icon-image = 23;
      menu-button-icon-size = 21;
      # menu-button-software-center = "pamac-manager";
      # menu-button-system-monitor = "gnome-terminal --maximize -- htop";
      # menu-button-terminal = "gnome-terminal";
      show-activities-button = false;
      show-lockorientation = false;
      show-lockscreen = true;
      show-power-options = false;
      symbolic-icon = true;
      use-custom-icon = false;
    };

    "org/gnome/shell/extensions/blur-me" = {
      blur-applications = true;
      blur-dash = true;
      blur-panel = true;
      brightness = 0.59999999999999998;
      dash-opacity = 0.12;
      hacks-level = 0;
      sigma = 30;
      static-blur = false;
      toggle-app-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      appfolder-dialog-opacity = 0.12;
      blur-dash = false;
      blur-panel = false;
      blur-window-list = true;
      brightness = 0.69999999999999996;
      dash-opacity = 0.12;
      debug = false;
      hacks-level = 0;
      hidetopbar = true;
      sigma = 15;
      static-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      # blacklist = @as "";
      blur = false;
      enable-all = true;
      # whitelist = @as "";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
      customize = false;
      override-background = false;
      unblur-in-overview = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
      brightness = 0.64000000000000001;
      customize = false;
      noise-amount = 0.0;
      override-background = false;
      sigma = 65;
      static-blur = true;
      style-panel = 0;
      unblur-in-overview = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      blur = true;
    };

    "org/gnome/shell/extensions/burn-my-windows" = {
      active-profile = "/home/alexb/.config/burn-my-windows/profiles/1714602872515647.conf";
      last-extension-version = 37;
      last-prefs-version = 37;
      prefs-open-count = 20;
      show-support-dialog = false;
    };

    "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
      resize-effect = true;
    };

    "org/gnome/shell/extensions/coverflowalttab" = {
      current-workspace-only = "all";
      elastic-mode = false;
      icon-style = "Overlay";
      position = "Bottom";
      switcher-background-color = [
        0.27058823529411763
        0.27843137254901962
        0.35294117647058826
      ];
      switcher-style = "Coverflow";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      always-center-icons = true;
      animation-time = 0.24999999999999967;
      apply-custom-theme = true;
      autohide-in-fullscreen = true;
      background-color = "rgb(255,255,255)";
      background-opacity = 0.5;
      border-radius = 28;
      click-action = "focus-minimize-or-previews";
      custom-background-color = true;
      custom-theme-customize-running-dots = false;
      custom-theme-shrink = false;
      customize-alphas = true;
      dash-max-icon-size = 72;
      dock-position = "BOTTOM";
      extend-height = false;
      floating-margin = 5;
      force-straight-corner = false;
      height-fraction = 0.90000000000000002;
      hide-delay = 1.0;
      hot-keys = true;
      icon-size-fixed = true;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      isolate-monitors = false;
      isolate-workspaces = false;
      max-alpha = 0.78000000000000003;
      middle-click-action = "launch";
      min-alpha = 0.29999999999999999;
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      preview-size-scale = 0.0;
      require-pressure-to-show = false;
      running-indicator-dominant-color = false;
      running-indicator-style = "DOTS";
      scroll-action = "cycle-windows";
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-apps-at-top = true;
      show-delay = 0.20000000000000001;
      show-favorites = true;
      show-mounts = false;
      show-mounts-network = true;
      show-show-apps-button = true;
      show-trash = false;
      transparency-mode = "DYNAMIC";
      unity-backlit-items = false;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = false;
      app-menu = true;
      app-menu-icon = true;
      app-menu-label = true;
      calendar = false;
      clock-menu = true;
      dash = true;
      dash-icon-size = 0;
      events-button = true;
      keyboard-layout = false;
      notification-banner-position = 1;
      panel = true;
      panel-in-overview = true;
      panel-notification-icon = true;
      panel-size = 0;
      ripple-box = true;
      screen-sharing-indicator = true;
      search = true;
      show-apps-button = true;
      startup-status = 0;
      theme = false;
      weather = false;
      window-demands-attention-focus = true;
      window-picker-icon = false;
      workspace = false;
      workspace-popup = true;
      workspaces-in-app-grid = false;
      world-clock = false;
    };

    "org/gnome/shell/extensions/mediacontrols" = {
      colored-player-icon = false;
      extension-position = "center";
      mouse-actions = [
        "toggle_info"
        "none"
        "none"
        "none"
        "none"
        "none"
        "none"
        "none"
      ];
      prefer-using-seek = true;
      seperator-chars = [
        "|"
        "|"
      ];
      show-control-icons = false;
      show-next-icon = true;
      show-player-icon = false;
      show-playpause-icon = true;
      show-prev-icon = true;
      show-seperators = false;
      show-sources-menu = false;
      show-text = true;
      track-label = [
        "track"
        "-"
        "artist"
      ];
    };

    "org/gnome/shell/extensions/notification-banner-reloaded" = {
      always-minimized = 1;
      anchor-horizontal = 1;
      animation-direction = 1;
      animation-time = 500;
    };

    "org/gnome/shell/extensions/order-icons" = {
      icons-blacklist = [
        "Another Window Session Manager"
        "activities"
      ];
      order-icons-center = [
        "Media Controls"
        "dateMenu"
        "media-player-controls"
        "media-player"
        "Media Player"
        "media_controls_extension"
      ];
      order-icons-left = [
        "LogoMenu"
        "ArcMenu"
        "dash-button"
        "Workspace Indicator"
        "uniteWindowControls"
        "Notifications"
        "menuButton"
        "activities"
        "appMenu"
        "uniteDesktopLabel"
        "uniteAppMenu"
      ];
      order-icons-right = [
        "soundloopback@raginggoblin.rijkenmiel.nl"
        "ArcMenu"
        "Notifications"
        "battery-bar"
        "Another Window Session Manager"
        "PamacUpdateIndicator"
        "/org/gnome/Shell/Extensions/GSConnect/Device/f229f07e623e9f57"
        "TrayIconsReloaded"
        "color-picker@tuberry"
        "clipboardIndicator"
        "bluetooth-battery@michalw.github.com"
        "workspace-indicator"
        "drive-menu"
        "tiling-assistant@leleat-on-github"
        "uniteTrayIndicator"
        "dateMenu"
        "quickSettings"
        "keyboard"
        "a11y"
        "dwellClick"
        "screenSharing"
        "screenRecording"
        "power-menu"
      ];
    };
    "org/gnome/shell/extensions/pickawindow" = {
      wm-instance = "";
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      add-dnd-quick-toggle-enabled = false;
      add-unsafe-quick-toggle-enabled = false;
      datemenu-fix-weather-widget = false;
      datemenu-remove-media-control = false;
      datemenu-remove-notifications = false;
      disable-adjust-content-border-radius = true;
      disable-remove-shadow = true;
      input-always-show = false;
      input-show-selected = false;
      last-unsafe-state = false;
      # list-buttons = {"name":"SystemItem","title":null,"visible":true},{"name":"OutputStreamSlider","title":null,"visible":true},{"name":"InputStreamSlider","title":null,"visible":false},{"name":"BrightnessItem","title":null,"visible":true},{"name":"NMWiredToggle","title":null,"visible":false},{"name":"NMWirelessToggle","title":"Wi-Fi","visible":true},{"name":"NMModemToggle","title":null,"visible":false},{"name":"NMBluetoothToggle","title":"Tether","visible":true},{"name":"NMVpnToggle","title":null,"visible":false},{"name":"BluetoothToggle","title":"Bluetooth","visible":true},{"name":"PowerProfilesToggle","title":"Power Mode","visible":true},{"name":"NightLightToggle","title":"Night Light","visible":true},{"name":"DarkModeToggle","title":"Dark Style","visible":true},{"name":"KeyboardBrightnessToggle","title":"Keyboard","visible":true},{"name":"RfkillToggle","title":"Aeroplane Mode","visible":true},{"name":"RotationToggle","title":"Auto Rotate","visible":false},{"name":"BackgroundAppsToggle","title":"No Background Apps","visible":false},{"name":"MediaSection","title":null,"visible":false}"";
      media-control-enabled = true;
      notifications-enabled = false;
      output-show-selected = false;
      user-removed-buttons = [
        "Notifications"
        "DarkModeToggle"
        "NightLightToggle"
        "RfkillToggle"
      ];
      volume-mixer-enabled = false;
      volume-mixer-position = "top";
      volume-mixer-show-description = false;
      volume-mixer-show-icon = true;
      volume-mixer-use-regex = true;
    };

    "org/gnome/shell/extensions/tiling-assistant" = {
      active-window-hint = 1;
      active-window-hint-color = "rgb(91,155,248)";
    };

    "org/gnome/shell/extensions/unite" = {
      app-menu-max-width = 0;
      desktop-name-text = "";
      extend-left-box = true;
      greyscale-tray-icons = true;
      hide-activities-button = "always";
      hide-app-menu-icon = false;
      hide-dropdown-arrows = true;
      hide-window-titlebars = "both";
      notifications-position = "right";
      reduce-panel-spacing = true;
      show-legacy-tray = false;
      show-window-buttons = "both";
      show-window-title = "both";
      window-buttons-placement = "left";
      window-buttons-theme = "catppuccin";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Mocha";
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.user-themes
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.autohide-battery
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.burn-my-windows
    gnomeExtensions.compiz-windows-effect
    gnomeExtensions.coverflow-alt-tab
    gnomeExtensions.just-perfection
    gnomeExtensions.logo-menu
    gnomeExtensions.media-controls
    gnomeExtensions.no-titlebar-when-maximized
    gnomeExtensions.notification-banner-reloaded
    gnomeExtensions.order-gnome-shell-extensions
    gnomeExtensions.pip-on-top
    gnomeExtensions.tiling-assistant
    gnomeExtensions.transparent-window-moving
    gnomeExtensions.unite
    gnomeExtensions.dash-to-dock
    catppuccin
  ];
}
