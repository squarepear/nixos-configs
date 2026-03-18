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

    system.core.flakePath = "/home/jeffrey/Development/nixos-configs";

    system.vendor.cpu = "arm";
    system.vendor.gpu = "undefined";

    system.profiles = [ "pearlab" ];
  };
}
