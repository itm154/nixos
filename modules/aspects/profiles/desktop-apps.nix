{ den, ... }:
{
  den.aspects.profiles.desktop-apps = {
    includes = [
      den.aspects.kitty
      den.aspects.zen-browser
      den.aspects.discord
      den.aspects.mpv
      den.aspects.tone3000
    ];
  };
}
