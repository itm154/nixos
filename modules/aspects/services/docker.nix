{ lib, den, ... }: {
  den.aspects.docker = {
    nixos = { user, config, ... }: {
      virtualisation.docker = {
        enable = true;
        # storageDriver = "btrfs";

        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };

      users.users.${user.userName}.extraGroups = [ "docker" ];

      hardware.nvidia-container-toolkit.enable = lib.mkIf config.hardware.nvidia.enabled true;
    };
  };
}
