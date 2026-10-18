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

      # Distribute hardware interrupts across all 6 CPU cores
      services.irqbalance.enable = true;

      # Workaround for Intel I219-LM e1000e hardware unit hangs & power saving
      boot.kernelParams = [ "pcie_aspm=off" ];
      boot.extraModprobeConfig = "options e1000e SmartPowerDownEnable=0";

      systemd.services.e1000e-workaround = {
        description = "Tune Intel I219 e1000e NIC buffers and offloads";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "NetworkManager.service"
        ];
        script = ''
          # Maximize RX and TX ring buffers to 4096 (prevents packet drops under CPU load)
          ${pkgs.ethtool}/sbin/ethtool -G eno1 rx 4096 tx 4096 || true

          # Disable offloads that cause hardware unit hangs
          ${pkgs.ethtool}/sbin/ethtool -K eno1 tso off gso off gro off tx off rx off || true

          # Disable Energy Efficient Ethernet
          ${pkgs.ethtool}/sbin/ethtool --set-eee eno1 eee off || true
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

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
        "d /srv/data 2775 itm154 users -"
      ];
    };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
