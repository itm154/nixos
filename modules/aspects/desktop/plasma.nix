{ den, ... }:
{
  den.aspects.plasma = {
    nixos = { pkgs, ... }: {
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        papirus-icon-theme
        klassy
        bibata-cursors
      ];

      # Plasma theme settings
      plasma = {
        enable = true;
        workspace = {
          clickItemTo = "select";
          lookAndFeel = "org.kde.breezedark-desktop";
          theme = "breeze-dark";
        };
      };
    };

    provides.to-users.homeManager = { pkgs, ... }: { };
  };
}
