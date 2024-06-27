{ pkgs, config, ... }:

{
  pear.user = {
    name = "jeffrey";
    publickey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyZWg5m3pXHOqNfdrO6ecghFfQowb/Y7Df7otocETHq";
  };

  users.users."${config.pear.user.name}" = {
    isNormalUser = true;
    description = "Jeffrey Harmon";
    group = "users";
    extraGroups = [ "wheel" "input" "audio" "video" "cdrom" "tty" ];
    home = "/home/${config.pear.user.name}";
    shell = pkgs.zsh;
    uid = 1000;

    # Authorized keys
    openssh.authorizedKeys.keys = [
      config.pear.user.publickey
    ];
  };

  nix.settings.trusted-users = [
    config.pear.user.name
  ];
}
