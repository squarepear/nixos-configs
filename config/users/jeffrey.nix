{ pkgs, ... }:

{
  users.users.jeffrey = {
    isNormalUser = true;
    description = "Jeffrey Harmon";
    group = "users";
    extraGroups = [ "wheel" ];
    home = "/home/jeffrey";
    shell = pkgs.zsh;
    uid = 1000;
  };

  nix.trustedUsers = [
    "jeffrey"
  ];
}
