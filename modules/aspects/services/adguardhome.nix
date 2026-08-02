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

      networking.nameservers = [
        "127.0.0.1"
        "::1"
      ];
    };
  };
}
