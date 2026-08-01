{ den, lib, ... }: {
  den.aspects.bootloader =
    {
      secureBoot ? false,
    }:
    {
      nixos = { pkgs, ... }: {
        boot.loader = {
          limine = {
            enable = true;
            maxGenerations = 5;

            # if secureBoot is enabled
            secureBoot = lib.mkIf secureBoot {
              enable = true;
              autoGenerateKeys = true;
              autoEnrollKeys.enable = true;
            };
          };
          systemd-boot.enable = lib.mkForce false;
          efi.canTouchEfiVariables = true;
        };

        boot.kernelParams = [
          "quiet"
          "splash"
        ];

        environment.systemPackages = [ pkgs.sbctl ];
      };
    };
}
