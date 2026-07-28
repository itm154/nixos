{ lib, den, ... }:
{
  den.default = {
    nixos = { pkgs, ... }: {
      system.stateVersion = "26.05";

      # Nix & Package Manager Settings
      nixpkgs.config.allowUnfree = true;
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
          "itm154"
        ];
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org"
          "https://nyx.chaotic.cx"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "chaotic-nyx.cachix.org-1:Rsvz1G/7wIlpools7Yf8M7s2lu8VRHMvD3t5/V237fU="
        ];
      };

      # Hardware & Firmware
      hardware.enableRedistributableFirmware = true;

      # Networking
      networking = {
        networkmanager.enable = true;
        useDHCP = lib.mkDefault true;
      };

      # Localization & Timezone
      time.timeZone = "Asia/Kuching";
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocales = [
          "en_US.UTF-8/UTF-8"
          "ms_MY.UTF-8/UTF-8"
          "ja_JP.UTF-8/UTF-8" # ha, weeb
        ];
      };

      # Keyboard & X Server
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Audio & Realtime Scheduling
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      # Security & Privilege Escalation
      security.polkit.enable = true;

      # Font Subsystem
      fonts.fontconfig.enable = true;

      # Home-manager settings
      programs.nh.enable = true;
      environment.systemPackages = with pkgs; [
        just
      ];
    };

    homeManager = { pkgs, ... }: {
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;

      home-manager.backupCommand = "${pkgs.trash-cli}/bin/trash-put";
    };
  };

  # Enable Home Manager by default for users
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
