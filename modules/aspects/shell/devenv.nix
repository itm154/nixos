{ den, ... }: {
  den.aspects.devenv = {
    homeManager = {
      programs.devenv = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
