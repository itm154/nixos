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
        };
        # TODO
        # plugins = with pkgs; {
        #   mediainfo = yaziPlugins.mediainfo;
        #   ouch = yaziPlugins.ouch;
        #   duckdb = {
        #     setup = true;
        #     package = yaziPlugins.duckdb;
        #   };
        # };
      };

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
