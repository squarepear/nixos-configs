{ ... }:

{
  # Enable OpenSSH
  services.openssh = {
    enable = true;

    forwardX11 = true;
    # Disable password authentication
    passwordAuthentication = false;
  };

  programs.ssh.extraConfig = ''
    Host *
      ConnectTimeout 3
  '';
}
