{ den, inputs, ... }:
{
  flake-file.inputs = {
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  den.aspects.plasma = {
    nixos = { pkgs, ... }: {
      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        GDK_BACKEND = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        GTK_USE_PORTAL = "1";
        SDL_VIDEODRIVER = "wayland";
      };
    };

    homeManager = { pkgs, ... }: {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      home.packages = with pkgs; [
        (catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "blue";
        })
        klassy
        bibata-cursors
        python314Packages.kde-material-you-colors
      ];

      xdg.configFile."klassy/klassyrc".source = ../files/klassyrc;

      programs.plasma = {
        enable = true;
        overrideConfig = false;

        configFile = {
          "kwinrc"."org.kde.kdecoration2" = {
            "BorderSize" = "None";
            "BorderSizeAuto" = "false";
            "ButtonsOnLeft" = "MFS";
            "ButtonsOnRight" = "HIAX";
          };
        };

        workspace = {
          iconTheme = "Papirus-Dark";
          widgetStyle = "Klassy";
          cursor.theme = "Bibata-Modern-Classic";
          windowDecorations = {
            library = "org.kde.klassy";
            theme = "";
          };
        };

        hotkeys = {
          commands = {
            "launch-terminal" = {
              name = "Launch terminal";
              command = "konsole";
              key = "Meta+Enter";
            };
          };
        };
      };
    };

    provides.to-users.homeManager = { pkgs, ... }: { };
  };
}
