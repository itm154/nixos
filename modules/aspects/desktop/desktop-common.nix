{ den, ... }: {
  den.aspects.desktop-common = {
    nixos = { pkgs, ... }: {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        bluetooth.enable = true;
      };

      services = {
        xserver.xkb = {
          layout = "us";
          variant = "";
        };
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };
        gvfs.enable = true;
        udisks2.enable = true;
      };

      security.rtkit.enable = true;

      fonts.fontconfig.enable = true;

      xdg.portal.enable = true;

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ];
    };
  };
}
