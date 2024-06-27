{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    rsync
  ];

  services.syncthing = {
    enable = true;

    user = config.pear.user.name;
    group = config.users.users.${config.pear.user.name}.group;
    dataDir = "/home/${config.pear.user.name}";
  };
}
