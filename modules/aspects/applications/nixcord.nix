{ den, inputs, ... }: {
  flake-file.inputs = {
    nixcord.url = "github:4evy/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.discord = {
    homeManager = {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];

      programs.nixcord = {
        enable = true;
        discord.vencord.enable = true;
        discord.krisp.enable = true;
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
    };
  };
}
