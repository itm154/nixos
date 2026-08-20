{ den, ... }: {
  den.aspects.desktop-common = {
    nixos = { pkgs, ... }: {
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            intel-media-driver
            libva-vdpau-driver
            libvdpau-va-gl
          ];
        };
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
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
        flatpak.enable = true;
      };

      security.pam.loginLimits = [
        {
          domain = "@audio";
          type = "-";
          item = "rtprio";
          value = "99";
        }
        {
          domain = "@audio";
          type = "-";
          item = "memlock";
          value = "unlimited";
        }
      ];

      security.rtkit.enable = true;

      xdg.portal.enable = true;

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      fonts = {
        fontconfig.enable = true;
        enableDefaultPackages = true;
        fontDir.enable = true;
        packages = with pkgs; [
          noto-fonts
          corefonts
        ];
      };
    };
  };
}
