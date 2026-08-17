{ den, ... }: {
  den.aspects.yazi = {
    homeManager = { pkgs, ... }: {
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        settings = {
          mgr = {
            sort_by = "natural";
            sort_dir_first = true;
          };
          opener = {
            extract = [
              {
                run = "${pkgs.ouch}/bin/ouch d -y \"$@\"";
                desc = "Extract here with ouch";
                for = "unix";
              }
            ];
          };
          plugin = {
            prepend_preloaders = [
              # Mediainfo
              {
                mime = "{audio,video,image}/*";
                run = "mediainfo";
              }
              {
                mime = "application/{subrip,postscript,illustrator,dvb.ait,vnd.adobe.illustrator,eps}";
                run = "mediainfo";
              }
              {
                url = "*.{ai,eps,ait}";
                run = "mediainfo";
              }
              {
                mime = "{image}/*";
                run = "mediainfo --no-metadata";
              }
              {
                mime = "{video}/*";
                run = "mediainfo --no-preview";
              }
            ];
            prepend_previewers = [
              # Mediainfo
              {
                mime = "{audio,video,image}/*";
                run = "mediainfo";
              }
              {
                mime = "application/{subrip,postscript,illustrator,dvb.ait,vnd.adobe.illustrator,eps}";
                run = "mediainfo";
              }
              {
                url = "*.{ai,eps,ait}";
                run = "mediainfo";
              }
              {
                mime = "{image}/*";
                run = "mediainfo --no-metadata";
              }
              {
                mime = "{video}/*";
                run = "mediainfo --no-preview";
              }

              # Ouch
              {
                mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
                run = "ouch";
              }
            ];
          };

          tasks = {
            image_alloc = 1073741824;
          };
        };
        plugins = with pkgs.yaziPlugins; {
          mediainfo = mediainfo;
          ouch = ouch;
          recycle-bin = {
            package = recycle-bin;
            setup = true;
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            # Recycle bin
            {
              on = [
                "<C-b>"
                "b"
              ];
              run = "plugin recycle-bin";
              desc = "Open Recycle Bin menu";
            }

            # Ouch
            {
              on = [ "C" ];
              run = "plugin ouch";
              desc = "Compress with ouch";
            }
          ];
        };
      };

      # Plugin dependencies
      home.packages = with pkgs; [
        mediainfo
        imagemagick
        trash-cli
      ];

      xdg.configFile."yazi/theme.toml".source = "${
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "yazi";
          rev = "baaf5d1c9427b836fbefd126aa855f9eab7a9d0d";
          sha256 = "sha256-L6SApM07CSQk0znEsFP8WaxW+ZHcindXo612r1XcwIg=";
        }
      }/themes/mocha/catppuccin-mocha-blue.toml";

      xdg.configFile."yazi/Catppuccin-mocha.tmTheme".source = "${
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
          sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
        }
      }/themes/Catppuccin Mocha.tmTheme";
    };
  };
}
