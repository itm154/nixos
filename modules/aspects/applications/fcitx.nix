{ den, ... }:
let
  catppuccin-fcitx5 =
    {
      stdenvNoCC,
      fetchFromGitHub,
      lib,
    }:
    stdenvNoCC.mkDerivation {
      pname = "catppuccin-fcitx5";
      version = "2025-05-17";

      src = fetchFromGitHub {
        owner = "catppuccin";
        repo = "fcitx5";
        rev = "393845cf3ed0e0000bfe57fe1b9ad75748e2547f";
        hash = "sha256-ss0kW+ulvMhxeZKBrjQ7E5Cya+02eJrGsE4OLEkqKks=";
      };

      dontBuild = true;

      installPhase = ''
        runHook preInstall

        patchShebangs ./enable-rounded.sh
        ./enable-rounded.sh

        mkdir -p $out/share/fcitx5/themes
        cp -r src/* $out/share/fcitx5/themes/

        runHook postInstall
      '';

      meta = {
        description = "Catppuccin theme for Fcitx5";
        homepage = "https://github.com/catppuccin/fcitx5";
        license = lib.licenses.mit;
        platforms = lib.platforms.all;
      };
    };
in
{
  den.aspects.fcitx = {
    nixos =
      { pkgs, ... }:
      let
        catppuccinTheme = pkgs.callPackage catppuccin-fcitx5 { };
      in
      {
        i18n.inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5 = {
            addons = with pkgs; [
              fcitx5-mozc
              fcitx5-gtk
              catppuccinTheme
            ];
            waylandFrontend = true;
            settings.addons = {
              classicui.globalSection = {
                Theme = "catppuccin-mocha-blue";
                DarkTheme = "catppuccin-mocha-blue";
              };
            };
          };
        };
      };
  };
}
