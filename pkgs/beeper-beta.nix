{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  libsecret,
}: let
  pname = "beeper";
  version = "4.0.640";

  src = fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}.AppImage";
    hash = "sha256-hYbTYvfrTpRPRwXXgNCqKeEtiRpuLj6sYIYnfJ3aMv4=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      linuxConfigFilename=$(find $out/resources/app/build/main -name 'linux-*.mjs' -print -quit)
      if [[ -n "$linuxConfigFilename" ]]; then
        echo "Disabling runtime desktop integration in $linuxConfigFilename"
        sed -i 's/export function registerLinuxConfig().*/export function registerLinuxConfig() {}/' "$linuxConfigFilename"
      else
        echo "Warning: Could not find linux config file to patch for desktop integration."
      fi
    '';
  };
in
  appimageTools.wrapAppImage {
    inherit pname version;
    src = appimageContents;
    extraPkgs = pkgs: [libsecret];

    extraInstallCommands = ''
      mkdir -p $out/share/icons/hicolor/512x512/apps
      cp ${appimageContents}/usr/share/icons/hicolor/512x512/apps/beepertexts.png $out/share/icons/hicolor/512x512/apps/beeper.png

      install -Dm644 ${appimageContents}/beepertexts.desktop $out/share/applications/beeper.desktop

      substituteInPlace $out/share/applications/beeper.desktop \
        --replace-fail "AppRun" "beeper" \
        --replace-fail "Icon=beepertexts" "Icon=beeper"

      . ${makeWrapper}/nix-support/setup-hook
      wrapProgram $out/bin/beeper \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags "--no-update" \
        --set APPIMAGE "$out/bin/beeper"
    '';

    meta = {
      description = "Beeper - Universal chat app (packaged from AppImage)";
      longDescription = ''
        Beeper is a universal chat app. With Beeper, you can send
        and receive messages to friends, family and colleagues on
        many different chat networks. This package wraps the official AppImage.
      '';
      homepage = "https://beeper.com";
      license = lib.licenses.unfree;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      maintainers = with lib.maintainers; [];
      platforms = ["x86_64-linux"];
      mainProgram = "beeper";
    };
  }
