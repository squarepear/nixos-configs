{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    dotDir = ".config/zsh/";

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
      FILEBROWSER = "nautilus";
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
