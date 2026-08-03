{ den, ... }: {
  den.aspects.logiops = {
    nixos = {
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
                hires = true;
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
