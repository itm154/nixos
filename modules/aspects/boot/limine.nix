{ den, lib, ... }: {
  den.aspects.limine =
    {
      secure-boot ? false,
    }:
    {
      includes = lib.optional secure-boot den.aspects.secure-boot;
      nixos = { pkgs, ... }: {
        boot.loader = {
          limine.enable = true;
          systemd-boot.enable = false;
          efi.canTouchEfiVariables = true;
        };

        boot.kernelParams = [
          "quiet"
          "splash"
        ];
      };
    };
}
