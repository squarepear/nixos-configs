{ config, lib, ... }:

let
  usersCfg = config.pear.users;
in
rec {
  users = lib.attrNames usersCfg.users;
  admins = lib.filter (user: usersCfg.users.${user}.isAdmin) users;

  perUser = function: lib.genAttrs users (name: function name);
  perAdmin = function: lib.genAttrs admins (name: function name);
}
