{ lib, den, ... }: {
  den.aspects.docker = {
    nixos = { user, config, ... }: {
      virtualisation.docker = {
        enable = true;
        # storageDriver = "btrfs";

        daemon.settings = {
          log-driver = "json-file";
          log-opts = {
            "max-size" = "10m";
            "max-file" = "3";
          };
        };

        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };

      users.users.${user.userName}.extraGroups = [ "docker" ];
      networking.firewall = {
        checkReversePath = "loose";

        extraInputRules = ''
          iifname "docker0" accept
          iifname "br-*" accept
        '';

        extraForwardRules = ''
          iifname "docker0" accept
          oifname "docker0" accept
          iifname "br-*" accept
          oifname "br-*" accept
        '';
      };

      hardware.nvidia-container-toolkit.enable = lib.mkIf config.hardware.nvidia.enabled true;
    };
  };
}
