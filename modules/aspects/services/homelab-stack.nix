{ den, ... }: {
  den.aspects.homelab-stack = {
    includes = [
      den.aspects.qbittorrent
    ];
  };
}
