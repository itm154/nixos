{ den, inputs, ... }: {
  flake-file.inputs = {
    nixcord.url = "github:4evy/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.discord = {
    homeManager = { pkgs, ... }: {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        # Stock Discord Client + Vencord
        # discord.vencord.enable = true;
        # discord.krisp.enable = true;
        # discord.openASAR.enable = true;
        # discord.branches = [
        #   "ptb"
        # ];

        # Vesktop
        discord.enable = false;
        vesktop.enable = true;

        # Equibop
        # discord.enable = false;
        # equibop.enable = true;

        # Not including legcord here yet cus the icon sucks
        # Yes that was my real reason

        config = {
          useQuickCss = true;
          plugins = {
            blurNsfw.enable = true;
            callTimer.enable = true;
            clearUrls.enable = true;
            fakeProfileThemes.enable = true;
            gameActivityToggle.enable = true;
            hideMedia.enable = true;
            reverseImageSearch.enable = true;
            silentTyping.enable = true;
            validUser.enable = true;
            vcNarrator = {
              voice = null;
            };
          };
        };

        extraConfig.plugins = {
          fakeNitro = {
            useHyperLinks = true;
          };
          messageClickActions = {
            enableDeleteOnClick = true;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            requireModifier = false;
          };
          musicRichPresence = {
            showLastFmLogo = true;
          };
          noBlockedMessages = {
            applyToIgnoredUsers = true;
            ignoreBlockedMessages = false;
            ignoreMessages = false;
          };
          platformIndicators = {
            badges = true;
          };
          showHiddenChannels = {
            hideUnreads = true;
          };
          showMeYourName = {
            displayNames = false;
            friendNicknames = "dms";
            inReplies = false;
            mode = "user-nick";
          };
          silentTyping = {
            contextMenu = true;
            isEnabled = true;
            showIcon = false;
          };
          translate = {
            shavian = true;
            sitelen = true;
            target = "en";
            toki = true;
          };
        };

        quickCss = ''
          /**
           * @name Rounded Discord
           * @author MarkChan0225
           * @description A theme which make your Discord becomes rounded
           * @version 1.1.1
           * @invite 98gAY7v6y7
           * @authorId 608821416212692993
           * @source https://github.com/MarkChan0225/RoundedDiscord
          */

          @import url(https://MarkChan0225.github.io/RoundedDiscord/src/roundeddiscord.css);

          :root {
            --radius: 16px;
          }
        '';
      };

      # Things for arRPC to work with flatpak apps
      # Ref: https://github.com/Arcitec/discord-flatpak-rpc-bridge
      systemd.user = {
        sockets.discord-flatpak-rpc-bridge = {
          Unit = {
            Description = "Discord Native-to-Flatpak RPC Bridge Socket";
          };
          Socket = {
            Priority = 6;
            ListenStream = "%t/app/com.discordapp.Discord/discord-ipc-0";
          };
          Install = {
            WantedBy = [ "sockets.target" ];
          };
        };

        services.discord-flatpak-rpc-bridge = {
          Unit = {
            Description = "Discord Native-to-Flatpak RPC Bridge Service";
            Requires = [ "discord-flatpak-rpc-bridge.socket" ];
            After = [ "discord-flatpak-rpc-bridge.socket" ];
          };
          Service = {
            Type = "notify";
            ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd %t/discord-ipc-0";
            PrivateTmp = true;
            PrivateNetwork = true;
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };

    };
  };
}
