{ den, ... }: {
  den.aspects.adguardhome = {
    nixos = {
      services.adguardhome = {
        enable = true;
        mutableSettings = true;
        settings = {
          http.address = "0.0.0.0:8080";
        };
      };

      networking.firewall = {
        allowedTCPPorts = [
          53
          8080
        ];
        allowedUDPPorts = [ 53 ];
      };

      networking.nameservers = [
        "127.0.0.1"
        "::1"
        "1.1.1.1" # Fallback
      ];

      services.resolved = {
        settings.Resolve = {
          DNSStubListener = "no";
        };
      };
    };
  };
}
