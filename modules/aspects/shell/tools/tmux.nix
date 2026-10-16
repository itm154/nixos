{ den, ... }: {
  den.aspects.tmux = {
    homeManager = {
      programs.tmux = {
        enable = true;
        mouse = true;
        keyMode = "vi";
        baseIndex = 1;
        newSession = true;
      };
    };
  };
}
