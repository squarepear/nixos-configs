{ config, ... }:

{
  services.jellyfin = {
    enable = true;

    user = config.pear.user.name;
  };
}
