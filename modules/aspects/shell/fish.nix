{ den, ... }: {
  den.aspects.fish = {
    # includes = [
    #   (den.batteries.user-shell "fish")
    # ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        fishPlugins.autopair
        fishPlugins.bang-bang
      ];
    };
    homeManager = { pkgs, ... }: {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set -g fish_greeting
        '';
        plugins = [
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair.src;
          }
          {
            name = "bang-bang";
            src = pkgs.fishPlugins.bang-bang.src;
          }
        ];
        shellAliases = {
          ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first --icons";
          la = "${pkgs.eza}/bin/eza -a --color=always --group-directories-first --icons";
          ll = "${pkgs.eza}/bin/eza -l --color=always --group-directories-first --icons";
          lt = "${pkgs.eza}/bin/eza -aT --color=always --group-directories-first --icons";
          "l." = "${pkgs.eza}/bin/eza -a | grep -e '^\\.'";
        };
      };
    };
  };
}
