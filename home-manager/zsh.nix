{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pure-prompt
  ];

  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    dotDir = ".config/zsh";
    history.path = "$HOME/.cache/.zsh_history";

    completionInit = ''
      autoload -Uz compinit
      compinit
      # Completion for kitty
      kitty + complete setup zsh | source /dev/stdin
    '';
    
    initExtra = ''
      pfetch
      autoload -Uz promptinit; promptinit; prompt pure
    '';

    localVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      BROWSER = "brave";
      FILEBROWSER = "pcmanfm";
    };

    shellAliases = {
      cat = "bat";
      ssh = "kitty +kitten ssh";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };
  };
}
