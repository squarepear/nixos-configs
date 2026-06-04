{
  config,
  inputs,
  lib,
  pearlib,
  ...
}:

let
  cfg = config.pear.programs.nixvim;

  # Reuse the temporary palette used by the Hyprland module until a proper
  # `pear.colors` / `pear.theme` module exists.
  palette = import ../desktop/hyprland/colors.nix;

  # Convert { base00 = "0b0f14"; } -> { base00 = "#0b0f14"; }
  paletteWithHash = builtins.mapAttrs (_: color: "#${color}") palette;
in
{
  options.pear.programs.nixvim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
      description = "Enable nixvim / Neovim configuration for all users.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users = pearlib.perUser (_: {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        nixpkgs.source = inputs.nixpkgs-unstable;

        colorschemes.base16 = {
          enable = true;
          colorscheme = paletteWithHash;
        };

        plugins.lualine.enable = true;

        opts = {
          compatible = false;
          showmatch = true;
          ignorecase = true;
          hlsearch = true;
          incsearch = true;

          tabstop = 4;
          softtabstop = 4;
          expandtab = true;
          shiftwidth = 4;
          autoindent = true;

          number = true;
          wildmode = "longest,list";
          colorcolumn = "80";
          cursorline = true;
          ttyfast = true;

          mouse = "a";
          clipboard = "unnamedplus";

          # Equivalent to: filetype plugin indent on + syntax on
          filetype = "on";
          syntax = "on";
        };
      };
    });
  };
}
