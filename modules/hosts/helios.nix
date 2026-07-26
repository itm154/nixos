{ den, ... }:
{
  # host aspect
  den.aspects.helios = {
    # host NixOS configuration
    includes = [ den.batteries.hostname ];
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.hello ];
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vim ];
      };
  };
}
