{ den, ... }:
{
  # user aspect
  den.aspects.itm154 = {
    includes = [
      den.aspects.itm154-base

      den.aspects.profiles.desktop-apps
    ];

    homeManager =
      { pkgs, osConfig, ... }:
      {
        programs.ssh.settings = {
          "*" = {
            IdentityFile = [
              osConfig.sops.secrets.helios_ssh_key.path
            ];
          };

          # Alias for homelab
          "apollo" = {
            HostName = "apollo";
            User = "itm154";
          };
        };

        # Applications that dont require specific config
        home.packages = with pkgs; [
          carla
          libreoffice
          localsend
          prismlauncher
          typst
          wineWow64Packages.stable
          winetricks
          yabridge
          yabridgectl

          # Fonts
          fira-sans
          font-awesome
          roboto
          source-sans
          source-sans-pro
        ];

        fonts.fontconfig.enable = true;

        # Options that idt needs a seperate module
        programs.obs-studio = {
          enable = true;
          package = (
            pkgs.obs-studio.override {
              cudaSupport = true;
            }
          );
        };
      };
  };
}
