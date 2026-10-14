{ den, ... }:
{
  den.aspects.itm154-base = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      den.batteries.host-aspects

      (den.batteries.user-shell "fish")

      # Git, terminal, cli applications, etc...
      den.aspects.devtools
      den.aspects.devenv
      den.aspects.zoxide

      # Terminal editor
      den.aspects.neovim
    ];

    user = {
      extraGroups = [ "audio" ];
      initialPassword = "1234";
    };

    homeManager =
      { pkgs, ... }:
      {
        # Applications that dont require specific config
        home.packages = with pkgs; [
          lazydocker
        ];
      };
  };
}
