{ den, inputs, ... }: {
  flake-file.inputs = {
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.gaming = {
    nixos = { pkgs, ... }: {
      nixpkgs.overlays = [
        inputs.millennium.overlays.default
      ];
      programs.steam = {
        enable = true;
        package = pkgs.millennium-steam;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
        # Other general flags if available can be set here.
      };
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
      programs.gamemode.enable = true;
      environment.systemPackages = [ pkgs.mangohud ];
    };
  };
}
