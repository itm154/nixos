{ den, ... }: {
  den.aspects.mpv = {
    homeManager = { pkgs, ... }: {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          modernz
          thumbfast
        ];
      };
    };
  };
}
