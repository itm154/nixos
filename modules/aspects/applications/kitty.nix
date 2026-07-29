{ den, ... }: {
  den.aspects.kitty = {
    homeManager = { pkgs, ... }: {
      programs.kitty = {
        enable = true;
        shellIntegration = {
          enableFishIntegration = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
        };
        enableGitIntegration = true;
        themeFile = "Catppuccin-Mocha";
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 16;
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        settings = {
          enable_audio_bell = "no";
          tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
          cursor_trail = 1;
        };
        keybindings = {
          "kitty_mod+k" = "next_tab";
          "kitty_mod+j" = "previous_tab";
          "kitty_mod+t" = "launch --type=tab --cwd=current";
          "kitty_mod+q" = "close_tab";
          "cmd+w" = "close_tab";

          "kitty_mod+L" = "no_op";
          "kitty_mod+H" = "no_op";
        };

      };
    };
  };
}
