{ den, ... }:
{
  # user aspect
  den.aspects.itm154 = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects

      (den.batteries.user-shell "fish")

      # Git, terminal, cli applications, etc...
      den.aspects.devtools
      den.aspects.devenv

      # Applications that require config
      den.aspects.kitty
      den.aspects.neovim
      den.aspects.zen-browser
      den.aspects.discord
      den.aspects.mpv
      den.aspects.gaming
      den.aspects.virtualization
    ];

    user = {
      extraGroups = [ "audio" ];
    };

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
          lazydocker

          wineWow64Packages.stable

          yabridge
          yabridgectl
          carla
          winetricks

          localsend

          prismlauncher
        ];
      };

    user = {
      initialPassword = "1234";
    };
  };
}
