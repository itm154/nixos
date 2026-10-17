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
      den.aspects.adguardhome

      den.aspects.tmux
    ];

    nixos = { pkgs, ... }: {
      imports = [ /etc/nixos/hardware-configuration.nix ];
      environment.systemPackages = with pkgs; [ ethtool ];

      networking.firewall.allowedTCPPorts = [
        80
        81
        443
      ];

      # Workaround for Intel I219-LM e1000e hardware unit hangs & power saving
      boot.kernelParams = [ "pcie_aspm=off" ];
      boot.extraModprobeConfig = "options e1000e EEE=0";

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", DRIVERS=="e1000e", RUN+="${pkgs.ethtool}/sbin/ethtool -K %k tso off gso off gro off"
        ACTION=="add", SUBSYSTEM=="net", DRIVERS=="e1000e", RUN+="${pkgs.ethtool}/sbin/ethtool --set-eee %k eee off"
      '';

      # Prevent homelab server from sleeping or suspending
      systemd.targets.sleep.enable = false;
      systemd.targets.suspend.enable = false;
      systemd.targets.hibernate.enable = false;
      systemd.targets.hybrid-sleep.enable = false;

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
        priority = 100;
      };

      systemd.tmpfiles.rules = [
        "d /srv/docker 0775 itm154 users -"
        "d /srv/media 2775 itm154 users -"
      ];
    };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
