{ den, ... }:
{
  # user aspect
  den.aspects.itm154 = {
    includes = [
      den.aspects.itm154-base

      # Applications that require config
      den.aspects.kitty
      den.aspects.zen-browser
      den.aspects.discord
      den.aspects.mpv
      den.aspects.gaming
      den.aspects.virtualization
      den.aspects.tone3000

      den.aspects.fcitx
    ];

    nixos = {
      networking.firewall.allowedTCPPorts = [
        53317 # localsend
        8096 # jellyfin (LAN streaming)
      ];
      networking.firewall.allowedUDPPorts = [
        53317 # localsend
        8096 # jellyfin (LAN streaming)
      ];
    };

    homeManager =
      { pkgs, ... }:
      {
        # Applications that dont require specific config
        home.packages = with pkgs; [
          wineWow64Packages.stable

          yabridge
          yabridgectl
          carla
          winetricks

          localsend

          prismlauncher

          reaper
          fira-sans
          roboto

          libreoffice

          blender

          typst

          # Fonts
          font-awesome
          roboto
          source-sans-pro
          source-sans
        ];

        fonts.fontconfig.enable = true;

        # Options that idt needs a seperate module
        programs.obs-studio = {
          enable = true;
          package = (
            pkgs.obs-studio.override {
              cudaSupport = true;
            }
          );
        };
      };
  };
}
