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

      # =========================================================================================
      # WARNING: This section is mostly added by gemini/antigravity
      # I was tired of debugging network issues

      # Distribute hardware interrupts across all CPU cores
      services.irqbalance.enable = true;

      # Google BBR & High-Throughput Network Stack Tuning (for BitTorrent & Jellyfin streaming)
      boot.kernelModules = [ "tcp_bbr" ];
      boot.kernel.sysctl = {
        # BBR Congestion Control & FQ scheduler
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";

        # Buffer sizing for Gigabit / 2.5G transfers & multi-peer swarms
        "net.core.rmem_max" = 16777216; # 16 MB
        "net.core.wmem_max" = 16777216; # 16 MB
        "net.core.rmem_default" = 1048576;
        "net.core.wmem_default" = 1048576;
        "net.core.netdev_max_backlog" = 16384;

        # Fast socket cleanup under high peer connection counts
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_fin_timeout" = 15;
      };

      # Keep Realtek RTL8156B 2.5G USB NIC permanently awake (disable autosuspend)
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/control}="on", ATTR{power/autosuspend}="-1"
      '';

      # Workaround for Intel I219-LM e1000e hardware unit hangs & power saving
      boot.kernelParams = [ "pcie_aspm=off" ];
      boot.extraModprobeConfig = "options e1000e SmartPowerDownEnable=0";

      systemd.services.nic-tuning = {
        description = "Tune network interface buffers and power saving";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "NetworkManager.service"
        ];
        script = ''
          # Disable EEE latency transitions on Realtek 2.5G USB NIC
          ${pkgs.ethtool}/sbin/ethtool --set-eee enp0s20f0u1 eee off || true

          # Keep Intel I219 tuned if ever plugged in
          ${pkgs.ethtool}/sbin/ethtool -G eno1 rx 4096 tx 4096 || true
          ${pkgs.ethtool}/sbin/ethtool -K eno1 tso off gso off gro off tx off rx off || true
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

      # =========================================================================================

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

      # Homelab monitoring
      # Moved this from docker into a nix service since it seems pretty important
      # =========================================================================
      # FIXME: Temporary override to Beszel 0.21.1 to fix intel-gpu-top parsing bug.
      # Remove this overlay once nixpkgs is updated to beszel >= 0.21.1.
      nixpkgs.overlays = [
        (final: prev: {
          beszel = prev.beszel.overrideAttrs (oldAttrs: rec {
            version = "0.21.1";
            src = prev.fetchFromGitHub {
              owner = "henrygd";
              repo = "beszel";
              tag = "v${version}";
              hash = "sha256-OB1pbfUKeE+tu/ehhoJhkPBmOBDLiQzGxb74bin2Qmg=";
            };
            webui = prev.buildNpmPackage {
              pname = "beszel-webui";
              inherit version src;
              sourceRoot = "${src.name}/internal/site";
              npmDepsHash = "sha256-pL4Qmi17CC4t6G/Mw/AgZUPf6cl0UPm75zfHVfrkoKI=";
              npmFlags = [ "--legacy-peer-deps" ];
              buildPhase = ''
                runHook preBuild
                npx lingui extract --overwrite
                npx lingui compile
                node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build
                runHook postBuild
              '';
              installPhase = ''
                runHook preInstall
                mkdir -p $out
                cp -r dist/* $out
                runHook postInstall
              '';
            };
            vendorHash = "sha256-NStpXYnaVkJxmzT1fIPFqSNbNSJqpnC0LsVQweFOwcI=";
            preBuild = ''
              mkdir -p internal/site/dist
              cp -r ${webui}/* internal/site/dist
            '';
          });
        })
      ];
      # =========================================================================

      services.beszel = {
        hub = {
          enable = true;
          host = "0.0.0.0";
          environment = {
            APP_URL = "https://beszel.itm154.com";
          };
        };
        agent = {
          enable = true;
          environment = {
            LISTEN = "45876";
            KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTgGh7pIbdyYdU9861k1eV4rbTxTuwTI63fERabWpCQ";
            TOKEN = "b38b8c63-eac0-4837-bd2a-ae33e57e8c5c";
            HUB_URL = "https://beszel.itm154.com";
            GPU_COLLECTOR = [ "intel_gpu_top" ];
          };
          smartmon = {
            enable = true;
            deviceAllow = [
              "/dev/nvme0"
              "/dev/nvme0n1"
            ];
          };
        };
      };
    };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
