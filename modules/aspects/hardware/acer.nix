{ den, lib, ... }: {
  den.aspects.acer = {
    nixos =
      { config, pkgs, ... }:
      let
        acer-wmi-battery = config.boot.kernelPackages.callPackage (
          {
            lib,
            kernel,
          }:
          kernel.stdenv.mkDerivation {
            pname = "acer-wmi-battery";
            version = "0.2.0";

            src = pkgs.fetchFromGitHub {
              owner = "frederik-h";
              repo = "acer-wmi-battery";
              rev = "9f90d75cc9237aeed7964622d10dbdf4d2c7b518";
              sha256 = "sha256-CyKRpE3cnhEIFHc4Hal2PQUW7cd5k8+55S4QdSqGvNI=";
            };

            nativeBuildInputs = kernel.moduleBuildDependencies;

            hardeningDisable = [
              "pic"
              "format"
            ];

            makeFlags =
              (builtins.filter (x: !(lib.hasPrefix "O=" x || lib.hasPrefix "--eval=" x)) kernel.makeFlags)
              ++ [
                "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
              ];

            buildPhase = ''
              runHook preBuild
              make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) "''${makeFlagsArray[@]}" LLVM=1 LLVM_IAS=1 modules
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
              cp acer-wmi-battery.ko $out/lib/modules/${kernel.modDirVersion}/extra/
              runHook postInstall
            '';

            meta = with lib; {
              description = "A linux kernel driver for the Acer WMI battery health control interface";
              homepage = "https://github.com/frederik-h/acer-wmi-battery";
              license = licenses.gpl2Only;
              platforms = platforms.linux;
            };
          }
        ) { };

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
