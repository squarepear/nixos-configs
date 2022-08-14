{ pkgs, ... }:

{
  user.name = "jeffrey";

  users.users.jeffrey = {
    isNormalUser = true;
    description = "Jeffrey Harmon";
    group = "users";
    extraGroups = [ "wheel" ];
    home = "/home/jeffrey";
    shell = pkgs.zsh;
    uid = 1000;

    # Authorized keys
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6R0tD850LaMbSjrriau10t+onORK6r/SeGwawHEjUO 16364318+SquarePear@users.noreply.github.com"
    ];
  };

  nix.settings.trusted-users = [
    "jeffrey"
  ];
}
