{ pkgs, lib, inputs, ... }:

{
  my.programs.neovim = {
    enable = true;

    # Symlink aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = lib.fileContents ./init.vim;

    # Plugins to use
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-javascript
      typescript-vim
      copilot-vim

      coc-clangd
      coc-css
      coc-emmet
      coc-eslint
      coc-html
      coc-json
      coc-prettier
      coc-pyright
      coc-sh
      coc-tsserver
      coc-vimlsp
      coc-yaml
      coc-vetur
      coc-toml
      coc-git
      coc-docker
      coc-rust-analyzer
      coc-go
    ];

    # CoC
    coc = {
      enable = true;

      settings = {
        "suggest.noselect" = true;
        "suggest.enablePreview" = true;
        "suggest.enablePreselect" = false;
        "suggest.disableKind" = true;
      };
    };
  };
}
