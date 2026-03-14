{ ... }:
{
  pear = {
    users.users.jeffrey = {
      isAdmin = true;
      hashedPasswordAgeFile = ../../secrets/jeffrey/passwordfile.age;
    };

    programs.git.users.jeffrey = {
      name = "Jeffrey Harmon";
      email = "contact@jeffreyharmon.dev";
      signingKey = "EC6381EC5C7904E8";
    };

    services.ai.enable = true;
    programs.obs.enable = true;
    system.impermanence.enable = true;

    system.vendor.cpu = "amd";
    system.vendor.gpu = "amd";

    system.core.flakePath = "/home/jeffrey/Development/nixos-configs";

    system.profiles = [
      "desktop"
      "gaming"
      "development"
    ];
  };
}
