{ den, ... }: {
  den.aspects.plymouth = {
    nixos = { pkgs, ... }: {
      boot = {
        plymouth = {
          enable = true;
          theme = "connect";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "connect" ];
            })
          ];
          extraConfig = ''
            [Daemon]
            DeviceScale=1
          '';
        };

        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
          "splash"
        ];
      };
    };
  };
}
