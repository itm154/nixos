{ den, lib, ... }: {
  den.aspects.nvidia =
    {
      open ? true,
      enablePrime ? false,
      intelBusId ? "PCI:0@0:2:0",
      nvidiaBusId ? "PCI:1@0:0:0",
      ...
    }:
    {
      nixos = {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          inherit open;
          modesetting.enable = true;
          powerManagement = {
            enable = true;
            finegrained = false;
          };
          dynamicBoost.enable = true;
          prime = lib.mkIf enablePrime {
            sync.enable = true;
            inherit intelBusId nvidiaBusId;
          };
        };
      };
    };
}
