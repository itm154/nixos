{ inputs, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  # other inputs may be defined at a module using them.
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    den.url = "github:denful/den";

    flake-file.url = "github:vic/flake-file";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake-file.nixConfig = {
    extra-substituters = [
      "https://attic.xuyh0120.win/lantian"
      "https://cache.xinux.uz"
    ];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
  };
}
