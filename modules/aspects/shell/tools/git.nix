{ lib, den, ... }: {

  den.aspects.git = {
    includes = [
      den.aspects.sops
      den.aspects.ssh
    ];

    homeManager = { pkgs, osConfig, ... }: {
      programs.ssh.settings = {
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = osConfig.sops.secrets.github_ssh_key.path;
          IdentitiesOnly = "yes";
        };
      };

      programs.git = {
        enable = true;
        signing = {
          format = "ssh";
          signByDefault = true;
          key = osConfig.sops.secrets.signing_ssh_key.path;
        };
        settings = {
          include = {
            path = "${
              pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "delta";
                rev = "011516f5d14f66b771b3e716f29c77231e008c74";
                sha256 = "sha256-lztkxX9O41YossvRzpR7tqxMhDNT1Efy2JvkCwtsiXQ=";
              }
            }/catppuccin.gitconfig";
          };

          user = {
            name = "itm154";
            email = "ashrulfahmi@gmail.com";
          };

          core = {
            compression = 9;
            whitespace = "error";
            preloadindex = true;
          };

          advice = {
            addEmptyPathscec = false;
            pushNonFastForward = false;
            statusHints = false;
          };

          url = {
            "git@github.com:" = {
              insteadOf = [
                "github:"
                "https://github.com"
              ];
            };
            "git@github.com:itm154/" = {
              insteadOf = [
                "itm154:"
                "https://github.com/itm154/"
              ];
            };
          };

          init = {
            defaultBranch = "main";
          };

          push = {
            autoSetupRemote = true;
            default = "current";
          };

          pull = {
            default = "current";
            rebase = true;
          };

          rebase = {
            autoStash = true;
            missingCommitsCheck = "warn";
          };
        };
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options.features = "catppuccin-mocha";
      };

      programs.lazygit = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        settings = {
          gui = {
            nerdFontsVersion = "3";
            showBottomLine = false;
            showCommandLog = false;
            theme = {
              activeBorderColor = [
                "#f38ba8"
                "bold"
              ];
              inactiveBorderColor = [ "#a6adc8" ];
              optionsTextColor = [ "#89b4fa" ];
              selectedLineBgColor = [ "#313244" ];
              cherryPickedCommitBgColor = [ "#45475a" ];
              cherryPickedCommitFgColor = [ "#f38ba8" ];
              unstagedChangesColor = [ "#f38ba8" ];
              defaultFgColor = [ "#cdd6f4" ];
              searchingActiveBorderColor = [ "#f9e2af" ];
            };
          };
          git.pagers = [
            {
              colorArg = "always";
              pager = "${pkgs.delta}/bin/delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
            }
          ];
        };
      };
    };
  };
}
