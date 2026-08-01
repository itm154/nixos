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

    ];
    nixos =
      { pkgs, ... }:
      {
        # Uncomment this on real hardware
        # imports = [
        # 	/etc/nixos/hardware-configuration.nix
        # ];

        environment.systemPackages = [
          pkgs.neovim
          pkgs.hello
        ];
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vim ];
      };
  };
}
