{ den, inputs, ... }: {
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  den.aspects.zen-browser = {
    homeManager = { pkgs, system, ... }: {
      home.packages = [
        (inputs.zen-browser.packages."${system}".default.override {
          nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
        })
      ];
    };
  };
}
