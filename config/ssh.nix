{ config, ... }:

{
  # Enable OpenSSH
  services.openssh = {
    enable = true;

    # Disable password authentication
    settings = {
      PasswordAuthentication = false;
    };
  };

  programs.ssh.extraConfig = ''
    Host *
      ConnectTimeout 3
  '';

  users.users.root.openssh.authorizedKeys.keys = [
    config.user.publickey
  ];
}
