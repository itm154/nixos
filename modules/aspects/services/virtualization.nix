{ den, ... }: {
  den.aspects.virtualization = {
    nixos = { pkgs, user, ... }: {
      virtualisation.libvirtd = {
        enable = true;
      };
      environment.etc."libvirt/network.conf".text = ''
        firewall_backend = "nft"
      '';
      programs.virt-manager.enable = true;
      users.users.${user.userName}.extraGroups = [ "libvirtd" ];
      environment.systemPackages = with pkgs; [
        dnsmasq
      ];
      networking.firewall.trustedInterfaces = [ "virbr0" ];
      networking.nftables.enable = true;
    };
  };
}
