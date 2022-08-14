{ ... }:

{
  # Enable OpenSSH
  services.openssh = {
    enable = true;

    # Disable password authentication
    passwordAuthentication = false;
  };
}
