{ ... }:
{
  pear = {
    users.users.jeffrey = {
      isAdmin = true;
      hashedPasswordAgeFile = ../../secrets/jeffrey/passwordfile.age;
    };

    # ai.enable = true;
    desktop.enable = true;
    networking.tailscale.enable = false;
    services.impermanence.enable = true;
  };
}
