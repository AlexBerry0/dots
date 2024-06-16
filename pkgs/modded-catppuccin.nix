{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "modded-catppuccin";
  src = pkgs.fetchFromGitHub {
    owner = "AlexBerry0";
    repo = "Modded-Catppuccin-Mocha-GTK-theme";
    rev = "5ec4a99d456047dfe94d5724ab137f6de21abdc6";
    sha256 = "sha256-Ke4+jzxObBUejdmaAte2KOdBudbQ1jIyQ1Kb3kvFK9c=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    mv Catppuccin-Mocha/* ./
    rm -r Catppuccin-Mocha
    rm LISENCE
    rm README.md
  '';
}
