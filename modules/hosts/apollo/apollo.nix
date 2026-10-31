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

      # Network tuning
      # Enable Google's BBR tcp congestion algorithm
      # https://tie.pub/en/blog/how-to-deploy-google-bbr-on-linux/
      services.irqbalance.enable = true;
      boot.kernelModules = [ "tcp_bbr" ];
      boot.kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };

      # Disable autosuspend for USB with external NIC attached
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/control}="on", ATTR{power/autosuspend}="-1"
      '';

      # =========================================================================================
      # WARNING: This section is mostly added by gemini/antigravity
      # I manually verified what it does
      # Looks like its pulling from here
      # https://community-scripts.org/scripts/nic-offloading-fix?id=nic-offloading-fix
      # Workarounds for Intel I219-LM problem

      boot.kernelParams = [ "pcie_aspm=off" ];
      boot.extraModprobeConfig = "options e1000e SmartPowerDownEnable=0";

      systemd.services.nic-tuning = {
        description = "Disable EEE and offload for network cards";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "NetworkManager.service"
        ];
        script = ''
          ${pkgs.ethtool}/sbin/ethtool --set-eee enp0s20f0u1 eee off || true
          ${pkgs.ethtool}/sbin/ethtool --set-eee eno1 eee off || true
          ${pkgs.ethtool}/sbin/ethtool -K gso off gro off tso off tx off rx off rxvlan off txvlan off sg off || true
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
            GPU_COLLECTOR = [ "intel_gpu_top" ];
          };
          smartmon = {
            enable = true;
            deviceAllow = [
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
