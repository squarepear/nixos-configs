{ config, lib, ... }:

with lib;

{
  imports = [
    (mkAliasOptionModule [ "my" ] [ "home-manager" "users" "${config.user.name}" ])
  ];

  options = {
    user.name = mkOption {
      type = types.str;
      default = "jeffrey";
      description = "The name of the user.";
    };

    system.gui = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}
