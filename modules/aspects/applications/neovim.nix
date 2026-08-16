{ den, inputs, ... }: {
  flake-file.inputs = {
    # neovim.url = "github:itm154/nvim";
    neovim.url = "path:/home/itm154/Repository/nvim";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.neovim = {
    nixos = { system, ... }: {
      programs.neovim = {
        enable = true;
        package = inputs.neovim.packages.${system}.default;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;
      };
    };
  };
}
