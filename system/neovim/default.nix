{ config, inputs, ... }:

{
  my.imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  my.programs.nixvim = {
    enable = true;

    colorschemes.base16.enable = true;
    # Add a '#' prefix to every color in the palette.
    colorschemes.base16.colorscheme = builtins.mapAttrs (
      name: color: "#${color}"
    ) config.my.colorScheme.palette;
    plugins.lualine.enable = true;
  };
}
