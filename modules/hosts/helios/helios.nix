{ den, ... }:
{
  # host aspect
  den.aspects.helios = {
    # host NixOS configuration
    includes = [
      den.batteries.hostname

      (den.aspects.kernel-cachyos "latest-lto-x86_64-v3")
      (den.aspects.bootloader { secureBoot = true; })
      den.aspects.acer
      (den.aspects.nvidia { enablePrime = true; })

      den.aspects.profiles.workstation
    ];

    nixos = { pkgs, ... }: {
      imports = [ /etc/nixos/hardware-configuration.nix ];

      environment.systemPackages = with pkgs; [ ];

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
      };

      networking.firewall = {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
      };
    };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
