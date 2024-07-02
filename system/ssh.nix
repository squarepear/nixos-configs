{ config, ... }:

{
  # Enable OpenSSH
  services.openssh = {
    enable = true;

    # Disable password authentication
    settings = {
      PasswordAuthentication = false;
      LoginGraceTime = 0;
    };
  };

  programs.ssh.extraConfig = ''
    Host *
      ConnectTimeout 3
  '';

  users.users.root.openssh.authorizedKeys.keys = [
    config.pear.user.publickey
  ];
}
