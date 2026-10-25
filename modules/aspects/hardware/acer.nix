{ den, lib, ... }: {
  den.aspects.acer = {
    nixos =
      { config, pkgs, ... }:
      let
        # Temporary fix until https://github.com/NixOS/nixpkgs/pull/577973 is merged
        kpkgs = config.boot.kernelPackages;

        acer-wmi-battery = kpkgs.acer-wmi-battery.overrideAttrs (old: {
          makeFlags = (old.makeFlags or [ ]) ++ [
            "INSTALL_MOD_PATH=${placeholder "out"}"
            "INSTALL_MOD_DIR=kernel/drivers/platform/x86"
            "INSTALL_MOD_STRIP=1"
            "DEPMOD=true"
          ];

          installFlags = [
            "-C"
            "${kpkgs.kernel.dev}/lib/modules/${kpkgs.kernel.modDirVersion}/build"
            "M=$(PWD)"
          ];

          installTargets = [ "modules_install" ];
          installPhase = null;
        });

        healthmode = pkgs.writeShellApplication {
          name = "healthmode";
          runtimeInputs = with pkgs; [ coreutils ];
          text = ''
            SYSFS_PATH="/sys/bus/wmi/drivers/acer-wmi-battery/health_mode"

            if [ ! -e "$SYSFS_PATH" ]; then
              echo "Error: acer-wmi-battery driver is not loaded or health_mode sysfs node not found." >&2
              exit 1
            fi

            case "''${1:-}" in
              enable)
                if [ "$(id -u)" -ne 0 ]; then
                  exec sudo "$0" "$@"
                fi
                echo 1 > "$SYSFS_PATH"
                echo "Battery health mode enabled (80% charge limit)."
                ;;
              disable)
                if [ "$(id -u)" -ne 0 ]; then
                  exec sudo "$0" "$@"
                fi
                echo 0 > "$SYSFS_PATH"
                echo "Battery health mode disabled."
                ;;
              status)
                val=$(cat "$SYSFS_PATH" 2>/dev/null)
                if [ "$val" = "1" ]; then
                  echo "Health mode: enabled (80% limit)"
                elif [ "$val" = "0" ]; then
                  echo "Health mode: disabled"
                else
                  echo "Health mode status: $val"
                fi
                ;;
              *)
                echo "Usage: healthmode {enable|disable|status}" >&2
                exit 1
                ;;
            esac
          '';
        };
      in
      {
        boot.extraModulePackages = [ acer-wmi-battery ];
        boot.kernelModules = [ "acer-wmi-battery" ];
        environment.systemPackages = [ healthmode ];
      };
  };
}
