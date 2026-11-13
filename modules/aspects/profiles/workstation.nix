{ den, ... }:
{
  den.aspects.profiles.workstation = {
    includes = [
      den.aspects.plasma
      den.aspects.tailscale
      den.aspects.docker
      den.aspects.logiops
      den.aspects.printing
      den.aspects.neovim
      den.aspects.ssh
      den.aspects.virtualization
      den.aspects.gaming
      den.aspects.fcitx
    ];
  };
}
