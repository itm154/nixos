{ den, inputs, ... }: {
  flake-file.inputs = {
    nixcord.url = "github:4evy/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.discord = {
    homeManager = {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        discord.vencord.enable = true;
      };
    };
  };
}
