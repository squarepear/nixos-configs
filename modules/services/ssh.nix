{ config, lib, ... }:

let
  cfg = config.pear.services.ssh;
in
{
  options.pear.services.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenSSH
    services.openssh = {
      enable = true;

      # Disable password authentication
      settings = {
        PasswordAuthentication = false;
        LoginGraceTime = 0;
      };
    };
  };
}
