{ den, ... }:
{
  den.aspects.apollo = {
    includes = [
      den.batteries.hostname

      den.aspects.kernel-lts
      (den.aspects.bootloader { secureBoot = false; })
      den.aspects.docker
      # den.aspects.podman
      den.aspects.tailscale
    ];

    nixos = { pkgs, ... }: {
      imports = [ /etc/nixos/hardware-configuration.nix ];
      environment.systemPackages = with pkgs; [ ];
    };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
