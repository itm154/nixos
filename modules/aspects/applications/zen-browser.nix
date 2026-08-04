{ den, inputs, ... }: {
  flake-file.inputs = {
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.zen-browser = {
    homeManager = { pkgs, system, ... }: {
      home.packages = [
        (pkgs.wrapFirefox inputs.zen-browser.packages.${system}.zen-browser-unwrapped {
          pname = "zen-browser";
          nativeMessagingHosts = [
            pkgs.kdePackages.plasma-browser-integration
          ];
        })
      ];
    };
  };
}
