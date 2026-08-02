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
            defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
          };
        };

        hardware.nvidia-container-toolkit.enable = lib.mkIf config.hardware.nvidia.enabled true;

        users.users.${user.userName} = {
          linger = true;

          # Beware that the podman group membership is effectively equivalent
          # to being root, just like with Docker! Consider using rootless podman.
          # extraGroups = [
          #   "podman"
          # ];
        };

        services.resolved = {
          settings.Resolve = {
            DNSStubListener = "no";
          };
        };

        environment.systemPackages = with pkgs; [
          docker-compose
          podman-compose
        ];
      };
    homeManager = { pkgs, ... }: {
      # The default compose providers are docker-compose and podman-compose. If installed, docker-compose takes precedence since it is the original implementation of the Compose specification.
      services.podman.settings.containers = {
        compose_providers = [ "${pkgs.podman-compose}/bin/podman-compose" ];
        # or
        # compose_providers = [ "${pkgs.docker}/bin/docker-compose" ];
      };
    };
  };
}
