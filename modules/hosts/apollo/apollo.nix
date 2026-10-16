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
      environment.systemPackages = with pkgs; [ ];

      networking.firewall.allowedTCPPorts = [
        80
        81
        443
      ];

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
        priority = 100;
      };

      systemd.tmpfiles.rules = [
        "d /srv/docker 0775 itm154 users -"
        "d /srv/media 0775 itm154 users -"
      ];
    };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
