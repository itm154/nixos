{ den, inputs, ... }: {
  flake-file.inputs = {
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.zen-browser = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
