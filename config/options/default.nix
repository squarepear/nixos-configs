{ config, lib, ... }:

with lib;

{
  options = {
    system.gui = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = {
    home-manager.users.jeffrey = { ... }:
      let gui = config.system.gui.enable;
      in
      {
        options = {
          system.gui = {
            enable = mkOption {
              type = types.bool;
              default = gui;
            };
          };
        };
      };
  };
}
