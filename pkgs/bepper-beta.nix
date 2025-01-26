{
  lib,
  appimageTools,
  fetchurl,
}: let
  #   version = "1.4.0";
  pname = "beeper-beta";

  src = fetchurl {
    url = "https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop";
    hash = "sha256-EsTF7W1np5qbQQh3pdqsFe32olvGK3AowGWjqHPEfoM=";
  };

  appimageContents = appimageTools.extractType1 {inherit name src;};
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
    '';

    meta = {
      description = "Beeper beta version";
      homepage = "https://www.beeper.com/";
      downloadPage = "https://www.beeper.com/download";
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      maintainers = with lib.maintainers; [onny];
      platforms = ["x86_64-linux"];
    };
  }
