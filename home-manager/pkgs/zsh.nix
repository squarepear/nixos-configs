{ config, pkgs, ... }:

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
      ${ if config.programs.kitty.enable then "kitty + complete setup zsh | source /dev/stdin" else "# Not installed" }
    '';

    initExtra = ''
      pfetch
      fpath+=${pkgs.pure-prompt}/share/zsh/site-functions
      autoload -Uz promptinit; promptinit; prompt pure
      PATH=$PATH:$(go env GOPATH)/bin
    '';

    localVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      BROWSER = "firefox";
      FILEBROWSER = "pcmanfm";
    };

    shellAliases = {
      cat = "bat";
      ssh = if config.programs.kitty.enable then "kitty +kitten ssh" else "ssh";
    };

    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
    };
  };
}
