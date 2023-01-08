{ pkgs, config, ... }:

{
  user.name = "jeffrey";

  users.users."${config.user.name}" = {
    isNormalUser = true;
    description = "Jeffrey Harmon";
    group = "users";
    extraGroups = [ "wheel" ];
    home = "/home/${config.user.name}";
    shell = pkgs.zsh;
    uid = 1000;

    # Authorized keys
    openssh.authorizedKeys.keys = [
      config.user.publickey
    ];
  };

  nix.settings.trusted-users = [
    config.user.name
  ];
}
