{ den, ... }: {
  den.aspects.devtools = {
    includes = [
      den.aspects.fish
      den.aspects.fzf
      den.aspects.starship
      den.aspects.bat
      den.aspects.btop
      den.aspects.yazi
    ];
  };
}
