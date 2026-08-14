{ den, ... }: {
  den.aspects.zoxide = {
    homeManager = {
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        options = [ "--cmd cd" ];
      };
    };
  };
}
