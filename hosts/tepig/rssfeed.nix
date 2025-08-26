{ config, ... }:

{
  age.secrets.tepig-miniflux-admin.file = ../../secrets/tepig/miniflux-admin.age;

  services.miniflux = {
    enable = true;

    config.LISTEN_ADDR = "0.0.0.0:8082";
    adminCredentialsFile = config.age.secrets.tepig-miniflux-admin.path;
  };
}
