{
  den,
  inputs,
  lib,
  ...
}:
{
  flake-file.inputs = {
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.secure-boot =
    {
      enable-lanzaboote ? false,
    }:
    {
      nixos = { pkgs, ... }: {

        environment.systemPackages = [ pkgs.sbctl ];

        # Only apply boot.lanzaboote options if enabled
        # Lanzaboote needs systemd-boot
        imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
        boot.lanzaboote = lib.mkIf enable-lanzaboote {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
}
