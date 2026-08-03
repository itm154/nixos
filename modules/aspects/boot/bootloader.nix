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

            extraEntries = ''
              /Windows 11
                comment: Windows Boot Manager
                protocol: efi_chainload
                image_path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
            '';
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
