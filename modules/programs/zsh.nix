{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.programs.zsh;
in
{
  options.pear.programs.zsh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };

    isDefaultShell = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;
    programs.starship.enable = true;

    environment.pathsToLink = [ "/share/zsh" ];

    users.defaultUserShell = lib.mkIf cfg.isDefaultShell pkgs.zsh;

    home-manager.users = pearlib.perUser (name: {
      home.packages = with pkgs; [
        btop
        coreutils
        fastfetch
        fd
        jq
        just
        lsd
        ripgrep
        tree
        unzip
        util-linux
        wget
        xdg-utils
        zip
      ];

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = { };
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zsh =
        let
          homeDir = config.home-manager.users.${name}.home.homeDirectory;
        in
        {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          syntaxHighlighting.enable = true;
          autosuggestion.enable = false;
          autocd = true;

          dotDir = "${homeDir}/.config/zsh";
          history.path = "${homeDir}/.cache/.zsh_history";

          shellAliases = {
            cat = lib.getExe pkgs.bat;
            open = "${pkgs.xdg-utils}/bin/xdg-open";
            ls = lib.getExe pkgs.lsd;
            top = lib.getExe pkgs.btop;
          };

          # Global alias UUID
          shellGlobalAliases.UUID = "$(uuidgen | tr -d \\n)";

          sessionVariables = {
            EDITOR = "nvim";
            BROWSER = "firefox";
          };

          completionInit = ''
            autoload -Uz compinit
            compinit
            # Completion for kitty
            ${
              if config.pear.programs.kitty.enable then
                "kitty + complete setup zsh | source /dev/stdin"
              else
                "# Not installed"
            }
          '';

          initContent = ''
            ${lib.getExe pkgs.fastfetch}
          '';
        };

      programs.fastfetch = {
        enable = true;

        settings = {
          logo.source = "nixos_old_small";

          display = {
            separator = "";
            key.width = 8;
          };

          modules = [
            "title"
            {
              type = "os";
              key = "os";
            }
            {
              type = "host";
              key = "host";
            }
            {
              type = "kernel";
              key = "kernel";
            }
            {
              type = "uptime";
              key = "uptime";
            }
            {
              type = "packages";
              key = "pkgs";
            }
            {
              type = "memory";
              key = "memory";
            }
          ];
        };
      };
    });

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.files = [
        ".cache/.zsh_history"
      ];
    });
  };
}
