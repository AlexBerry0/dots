{
  lib,
  appimageTools,
}: let
  pname = "beeper-beta";
  version = "4.0.375";

  # Path to your local AppImage file
  localAppImage = ./local/assets/Beeper-Beta-4.0.375.AppImage;

  appimageContents = appimageTools.extractType1 {
    pname = pname;
    version = version;
    src = localAppImage;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version;

    src = localAppImage;

    extraInstallCommands = ''
      # Copy the .desktop file
      mkdir -p $out/share/applications
      cp ${appimageContents}/beepertexts.desktop $out/share/applications/${pname}.desktop

      # Update the .desktop file
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=./beepertexts' 'Exec=${pname}' \
        --replace 'Exec=./AppRun' 'Exec=${pname}'

      # Ensure the executable is accessible
      mkdir -p $out/bin
      cp ${appimageContents}/beepertexts $out/bin/${pname}
      chmod +x $out/bin/${pname}

      # Copy the icon
      mkdir -p $out/share/icons/hicolor/0x0/apps
      cp ${appimageContents}/usr/share/icons/hicolor/0x0/apps/beepertexts.png \
        $out/share/icons/hicolor/0x0/apps/${pname}.png
    '';

    meta = {
      description = "Beeper beta version (from local AppImage)";
      homepage = "https://www.beeper.com/";
      license = lib.licenses.asl20;
    };
  }
