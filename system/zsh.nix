{ config, pkgs, ... }:

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

    initExtra = ''
      pfetch
    '';

    localVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      cat = "bat";
      # ssh = if config.programs.kitty.enable then "kitty +kitten ssh" else "ssh";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };
  };

  my.programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Starship Config
    };
  };
}
