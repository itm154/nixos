{ den, inputs, ... }: {
  flake-file.inputs = {
    # neovim.url = "github:itm154/nvim";
    neovim.url = "path:/home/itm154/Repository/nvim";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.neovim = {
    homeManager = { system, ... }: {
      home.packages = [ inputs.neovim.packages.${system}.default ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
