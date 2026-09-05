{ den, ... }:
let
  overlay = import ../../../packages;
in
{
  den.aspects.tone3000 = {
    homeManager =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          overlay
        ];

        home.packages = [
          pkgs.tone3000
          pkgs.glib-networking
        ];

        home.sessionVariables = {
          GIO_EXTRA_MODULES = "${pkgs.glib-networking}/lib/gio/modules";
        };

        home.file.".vst3/TONE3000.vst3".source = "${pkgs.tone3000}/lib/vst3/TONE3000.vst3";
        home.file.".lv2/TONE3000.lv2".source = "${pkgs.tone3000}/lib/lv2/TONE3000.lv2";
        home.file.".clap/TONE3000.clap".source = "${pkgs.tone3000}/lib/clap/TONE3000.clap";
        home.file.".config/TONE3000/Presets/Factory".source =
          "${pkgs.tone3000}/share/TONE3000/Presets/Factory";
      };

    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          overlay
        ];

        environment.sessionVariables = {
          GIO_EXTRA_MODULES = [
            "${pkgs.glib-networking}/lib/gio/modules"
          ];
        };
      };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.tone3000 = pkgs.callPackage ../../../packages/tone3000 { };
    };
}
