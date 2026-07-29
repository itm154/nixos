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
      };

      # Hardware & Firmware
      hardware.enableRedistributableFirmware = true;

      # Networking
      networking = {
        networkmanager.enable = true;
        useDHCP = lib.mkDefault true;
      };
      services.resolved.enable = true;
      programs.ssh.startAgent = true;

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

      # Security & Privilege Escalation
      security.polkit.enable = true;

      # Others
      programs.nh.enable = true;
      environment.systemPackages = with pkgs; [
        git
        just
        curl
        wget
        ripgrep
        fzf
        fd
        pciutils
        usbutils
        htop
      ];

      # Override this if using plasma
      services.gnome.gnome-keyring.enable = lib.mkDefault true;
    };

    homeManager = { pkgs, ... }: {
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };

    # This is not Den's home manager module
    home-manager = { pkgs, ... }: {
      overwriteBackup = true;
      backupFileExtension = "backup";
      backupCommand = "${pkgs.trash-cli}/bin/trash-put";
    };
  };

  # Enable Home Manager by default for users
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
