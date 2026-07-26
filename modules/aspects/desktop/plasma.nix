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

      xdg.configFile."klassy/klassyrc".source = ./presets/klassyrc;

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
