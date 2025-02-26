{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "4.0.470";
  pname = "beepertexts";

  src = fetchurl {
    url = "https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop";
    hash = "sha256-uHvXBz2y5kN8mU/cAaQbLgmsWtdPVUf70M4CLcYwsTg=";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
  }
#   appimageContents = appimageTools.extractType1 {inherit pname version src;};
# in
#   appimageTools.wrapType2 rec {
#     inherit pname version src;
#     extraInstallCommands = ''
#       cp -R ${appimageContents} $out
#       mkdir -p $out/share/applications
#       cp ${appimageContents}/beepertexts.desktop $_
#     '';
#   meta = {
#     description = "Beeper beta version";
#     homepage = "https://www.beeper.com/";
#     downloadPage = "https://www.beeper.com/download";
#     license = lib.licenses.asl20;
#     sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
#     maintainers = with lib.maintainers; [onny];
#     platforms = ["x86_64-linux"];
#     mainProgram = "AppRun"; # Define the main program explicitly
#   };
# }

