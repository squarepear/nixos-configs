{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    # Symlink aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Plugins to use
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-javascript
      typescript-vim
    ];

    # Integrations
    withNodeJs = true;
    withPython3 = true;
  };
}
