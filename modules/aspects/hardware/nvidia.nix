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
      nixos = { pkgs, config, ... }: {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
          ];
        };

        services.xserver.videoDrivers = [
          "modesetting"
          "nvidia"
        ];

        hardware.nvidia = {
          inherit open;
          package = config.boot.kernelPackages.nvidiaPackages.latest;
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
