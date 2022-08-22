{ ... }:

{
  # Enable OpenSSH
  services.openssh = {
    enable = true;

    # Disable password authentication
    passwordAuthentication = false;
  };

  programs.ssh.extraConfig = ''
    Host *
      ConnectTimeout 3
  '';
}
