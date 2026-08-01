{ den, ... }:
{
  # user aspect
  den.aspects.itm154 = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects

      (den.batteries.user-shell "fish")

      den.aspects.devtools

      den.aspects.kitty
      den.aspects.zen-browser
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.htop ];
      };

    user = {
      initialPassword = "1234";
    };
  };
}
