# defines all hosts + users + homes.
# then config their aspects in as many files you want
{ den, ... }:
{
  den.hosts.x86_64-linux.helios.users.itm154 = { }; # Laptop
  den.hosts.x86_64-linux.apollo.users.itm154.aspect = den.aspects.itm154-base; # Homelab, headless
  den.homes.x86_64-linux.itm154 = { };

  # be sure to add nix-darwin input for this:
  # den.hosts.aarch64-darwin.apple.users.alice = { };

  # other hosts can also have user tux.
  # den.hosts.x86_64-linux.south = {
  #   wsl = { }; # add nixos-wsl input for this.
  #   users.tux = { };
  #   users.orca = { };
  # };
}
