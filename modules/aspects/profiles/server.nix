{ den, ... }:
{
  den.aspects.profiles.server = {
    includes = [
      den.aspects.docker
      den.aspects.tailscale
      den.aspects.adguardhome
      den.aspects.tmux
      den.aspects.neovim
      den.aspects.ssh
    ];
  };
}
