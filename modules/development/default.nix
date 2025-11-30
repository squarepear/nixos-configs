{ config, lib, ... }:

let
  cfg = config.pear.development;
in
{
  imports = [
    ./vscode.nix
  ];

  options.pear.development = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
  };
}
