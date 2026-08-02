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
    ];
    nixos =
      { pkgs, ... }:
      {
        # Uncomment this on real hardware
        # imports = [
        #	Requires --impure during rebuild
        # 	/etc/nixos/hardware-configuration.nix
        #
        # Or regenerate a hardware-configuration.nix file into _hardware-configuration/
        # nixos-generate-config
        #		./_hardware-configuration/hardware-configuration.nix
        # ];

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
