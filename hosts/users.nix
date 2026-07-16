{
  config,
  lib,
  ...
}:
{
  pear.users.users.jeffrey = {
    isAdmin = true;
    hashedPasswordAgeFile = ../secrets/jeffrey/passwordfile.age;
  };

  pear.programs.git.users.jeffrey = {
    name = "Jeffrey Harmon";
    email = "contact@jeffreyharmon.dev";
    signingKey = "EC6381EC5C7904E8";
  };
}
