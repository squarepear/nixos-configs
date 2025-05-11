{ config, lib, pkgs, ... }:

{
  programs.zsh.enable = true;

  # Used for auto completion
  environment.pathsToLink = [ "/share/zsh" ];

  my.programs.zsh = {
    enable = true;

    # enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    history.path = "$HOME/.cache/.zsh_history";

    completionInit = ''
      autoload -Uz compinit
      compinit
      # Completion for kitty
      ${ if config.my.programs.kitty.enable then "kitty + complete setup zsh | source /dev/stdin" else "# Not installed" }
    '';

    initContent = ''
      ${lib.getExe pkgs.fastfetch}
    '';

    localVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      cat = lib.getExe pkgs.bat;
      open = "${pkgs.xdg-utils}/bin/xdg-open";
      ls = lib.getExe pkgs.lsd;
      top = lib.getExe pkgs.btop;
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };
  };

  my.programs = {
    fastfetch = {
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

    starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        # Starship Config
      };
    };
  };
}
