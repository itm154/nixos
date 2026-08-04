{ den, ... }: {
  den.aspects.logiops = {
    nixos = {
      environment.etc."libinput/local-overrides.quirks".text = ''
        [Logitech MX Master 3]
        MatchVendor=0x46D
        MatchProduct=0xB034
        ModelInvertHorizontalScrolling=1
        AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
      '';

      boot.blacklistedKernelModules = [ "hid_logitech_hidpp" ];

      services.logiops = {
        enable = true;
        config = {
          devices = [
            {
              name = "MX Master 3S";
              dpi = 1000;
              smartshift = {
                on = true;
                threshold = 10;
              };
              hiresscroll = {
                hires = false;
                invert = false;
                target = false;
              };
            }
          ];
        };
      };
    };
  };
}
