{
  lib,
  stdenv,
  gnome,
  fetchFromGitHub,
  xprop,
  glib,
  ...
}: let
  close-active = ../media/unite-icons/close-active.svg;
  close-hover = ../media/unite-icons/close-hover.svg;
  close = ../media/unite-icons/close.svg;
  maximize-active = ../media/unite-icons/maximize-active.svg;
  maximize-hover = ../media/unite-icons/maximize-hover.svg;
  maximize = ../media/unite-icons/maximize.svg;
  minimize-active = ../media/unite-icons/minimize-active.svg;
  minimize-hover = ../media/unite-icons/minimize-hover.svg;
  minimize = ../media/unite-icons/minimize.svg;
in
  stdenv.mkDerivation rec {
    pname = "gnome-shell-extension-unite";
    version = "78";

    src = fetchFromGitHub {
      owner = "hardpixel";
      repo = "unite-shell";
      rev = "v${version}";
      hash = "sha256-4fOCgStMPzUg2QxYeX6tU/WUaGOn1YUyheZp6YNeODA=";
    };

    passthru = {
      extensionUuid = "unite@hardpixel.eu";
      extensionPortalSlug = "unite";
    };

    nativeBuildInputs = [glib];

    buildInputs = [xprop];

    buildPhase = ''
      runHook preBuild
      glib-compile-schemas --strict --targetdir="unite@hardpixel.eu/schemas/" "unite@hardpixel.eu/schemas"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions
      cp -r "unite@hardpixel.eu" $out/share/gnome-shell/extensions
      cd $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark
      find . ! -name 'stylesheet.css' -type f -exec rm -f {} +
      cp -r ${close-active} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/close-active.svg
      cp -r ${close-hover} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/close-hover}.svg
      cp -r ${close} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/close.svg
      cp -r ${maximize-active} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/maximize-active.svg
      cp -r ${maximize-hover} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/maximize-hover.svg
      cp -r ${maximize} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/maximize.svg
      cp -r ${minimize-active} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/minimize-active.svg
      cp -r ${minimize-hover} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/minimize-hover.svg
      cp -r ${minimize} $out/share/gnome-shell/extensions/unite@hardpixel.eu/themes/catppuccin/dark/minimize.svg
      runHook postInstall
    '';

    meta = with lib; {
      description = "Unite is a GNOME Shell extension which makes a few layout tweaks to the top panel and removes window decorations to make it look like Ubuntu Unity Shell";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [rhoriguchi];
      homepage = "https://github.com/hardpixel/unite-shell";
      broken = versionOlder gnome.gnome-shell.version "3.32";
    };
  }
