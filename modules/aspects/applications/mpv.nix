{ den, ... }: {
  den.aspects.mpv = {
    homeManager = { pkgs, ... }: {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          modernz
          thumbfast
        ];
        config = {
          hwdec = "auto-safe";
          vo = "gpu-next";
          gpu-api = "vulkan";
          profile = "high-quality";
        };
      };
    };
  };
}
