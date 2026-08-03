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

    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.plasma = {
    includes = [
      den.aspects.desktop-common
    ];

    nixos = { pkgs, ... }: {
      services = {
        displayManager.plasma-login-manager.enable = true;
        desktopManager.plasma6.enable = true;
        gnome.gnome-keyring.enable = false;
      };

      security.pam.services = {
        plasma-login-manager.kwallet.enable = true;
        sddm.kwallet.enable = true;
        login.kwallet.enable = true;
      };

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        GDK_BACKEND = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        GTK_USE_PORTAL = "1";
        SDL_VIDEODRIVER = "wayland";
      };

      services.ddccontrol.enable = true;

      environment.systemPackages = with pkgs; [
        wl-clipboard
      ];
    };

    homeManager = { pkgs, system, ... }: {
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
        inputs.kwin-effects-better-blur-dx.packages.${system}.default

        kdePackages.ksshaskpass
      ];

      home.sessionVariables = {
        SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
        SSH_ASKPASS_REQUIRE = "prefer";
        PAM_KWALLET5_LOGIN = "/run/user/$UID/kwallet5.socket";
      };

      systemd.user.services.kwallet-socket-bridge = {
        Unit = {
          Description = "Bridge PAM KWallet5 socket to KWallet6";
          Before = [ "plasma-workspace.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c 'if [ -S /run/user/$UID/kwallet5.socket ]; then ln -sf /run/user/$UID/kwallet5.socket /run/user/$UID/kwallet6.socket; fi'";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      xdg.configFile."klassy/klassyrc".source = ../files/klassyrc;

      programs.plasma = {
        enable = true;
        overrideConfig = false;

        configFile = {
          "kwalletrc"."Wallet" = {
            "Default Wallet" = "kdewallet";
            "Enabled" = "true";
            "First Use" = "false";
          };

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
      };
    };

    provides.to-users.homeManager = { pkgs, ... }: { };
  };
}
