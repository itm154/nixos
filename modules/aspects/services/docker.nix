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
      networking.firewall = {
        checkReversePath = false;
        trustedInterfaces = [
          "docker0"
          "br-+"
        ];
        extraCommands = ''
          iptables -I FORWARD 1 -i br-+ -j ACCEPT
          iptables -I FORWARD 1 -o br-+ -j ACCEPT
        '';
      };

      hardware.nvidia-container-toolkit.enable = lib.mkIf config.hardware.nvidia.enabled true;
    };
  };
}
