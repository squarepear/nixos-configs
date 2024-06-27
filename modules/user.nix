{ config, lib, ... }:

with lib;

{
  imports = [
    (mkAliasOptionModule [ "my" ] [ "home-manager" "users" "${config.pear.user.name}" ])
  ];

  options.pear.user = {
    name = mkOption {
      type = types.str;
      default = "jeffrey";
      description = "The name of the user.";
    };

    publickey = mkOption {
      type = types.str;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyZWg5m3pXHOqNfdrO6ecghFfQowb/Y7Df7otocETHq";
      description = "The public key used for ssh.";
    };
  };
}
