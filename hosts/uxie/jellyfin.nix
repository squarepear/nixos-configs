{ config, ... }:

{
  services.jellyfin = {
    enable = true;

    openFirewall = true;
    user = config.pear.user.name;
  };
}
