{ den, ... }:
{
  # user aspect
  den.aspects.itm154 = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects

      (den.batteries.user-shell "fish")

      # Git, terminal, cli applications, etc...
      den.aspects.devtools

      # Applications that require config
      den.aspects.kitty
      den.aspects.zen-browser
      den.aspects.discord
      den.aspects.mpv
    ];

    homeManager =
      { pkgs, ... }:
      {
        # Applications that dont require specific config
        home.packages = with pkgs; [
          lazydocker
        ];
      };

    user = {
      initialPassword = "1234";
    };
  };
}
