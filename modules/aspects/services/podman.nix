{ lib, den, ... }: {
  den.aspects.podman = {
    nixos =
      {
        user,
        config,
        pkgs,
        ...
      }:
      {
        virtualisation = {
          containers = {
            enable = true;
            registries.settings = {
              registry = [
                { location = "docker.io"; }
                { location = "ghcr.io"; }
                { location = "lscr.io"; }
                { location = "quay.io"; }
              ];
            };
          };
          podman = {
            enable = true;
            dockerCompat = true;
            dockerSocket.enable = true;
            defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
          };
        };

        hardware.nvidia-container-toolkit.enable = lib.mkIf config.hardware.nvidia.enabled true;

        users.users.${user.userName} = {
          linger = true;

          # Beware that the podman group membership is effectively equivalent
          # to being root, just like with Docker! Consider using rootless podman.
          # dockerSocket needs user to be in this group to work
          # extraGroups = [
          #   "podman"
          # ];
        };

        services.resolved = {
          settings.Resolve = {
            DNSStubListener = "no";
          };
        };

        # Needed for nginx
        boot.kernel.sysctl = {
          "net.ipv4.ip_unprivileged_port_start" = 80;
        };

        environment.sessionVariables = {
          DOCKER_HOST = "unix://$${XDG_RUNTIME_DIR}/podman/podman.socket";
        };

        environment.systemPackages = with pkgs; [
          docker-compose
          podman-compose
        ];
      };

    homeManager = { pkgs, ... }: {
      # The default compose providers are docker-compose and podman-compose. If installed, docker-compose takes precedence since it is the original implementation of the Compose specification.
      services.podman.settings.containers = {
        compose_providers = [
          "${pkgs.docker-compose}/bin/docker-compose"
          "${pkgs.podman-compose}/bin/podman-compose"
        ];
      };

      systemd.user.services.podman-restart = {
        Unit = {
          Description = "Start podman containers on Boot";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.podman}/bin/podman restart --all --filter restart-policy=always --filter restart-policy=unless-stopped";
        };
      };
    };
  };
}
