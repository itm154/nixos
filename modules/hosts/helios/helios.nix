{ den, ... }:
{
  # host aspect
  den.aspects.helios = {
    # host NixOS configuration
    includes = [
      den.batteries.hostname
      den.aspects.plasma
      (den.aspects.kernel-cachyos "latest-lto-x86_64-v3")
      (den.aspects.bootloader { secureBoot = true; })
      (den.aspects.nvidia { enablePrime = true; })

      den.aspects.tailscale
      # den.aspects.podman
      den.aspects.docker
      den.aspects.adguardhome
    ];
    nixos =
      { pkgs, ... }:
      {
	imports = [
		/etc/nixos/hardware-configuration.nix
	];

        environment.systemPackages = with pkgs; [ neovim ];
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
