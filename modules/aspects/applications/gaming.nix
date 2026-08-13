{ den, ... }: {
  den.aspects.gaming = {
    nixos = {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
        # Other general flags if available can be set here.
      };
      programs.gamemode.enable = true;
    };
  };
}
