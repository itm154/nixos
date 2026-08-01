{ den, inputs, ... }: {
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.sops = {
    nixos = { user, ... }: {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        defaultSopsFile = ../../../secrets.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = "/home/${user.userName}/.config/sops/age/keys.txt";
      };

      sops.secrets.github_ssh_key = {
        owner = "itm154";
      };
      sops.secrets.signing_ssh_key = {
        owner = "itm154";
      };
    };
  };
}
