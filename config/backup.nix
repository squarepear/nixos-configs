{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    rsync
  ];

  services.syncthing = {
    enable = true;

    user = config.user.name;
    group = config.users.users.${config.user.name}.group;
    dataDir = "/home/${config.user.name}";
  };
}
