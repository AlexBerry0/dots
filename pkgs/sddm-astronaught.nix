{pkgs}: let
  image = ../media/space_saturn.png;
in
  pkgs.stdenv.mkDerivation {
    name = "sddm-theme-astronaught";
    src = pkgs.fetchFromGitHub {
      owner = "Keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "48ea0a792711ac0c58cc74f7a03e2e7ba3dc2ac0";
      sha256 = "sha256-kXovz813BS+Mtbk6+nNNdnluwp/7V2e3KJLuIfiWRD0=";
    };
    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
      cd $out/
      ls
      cat Main.qml
      rm background.png
      cp -r ${image} $out/background.png
    '';
  }
