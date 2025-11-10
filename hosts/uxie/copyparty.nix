{ config, inputs, ... }:

{
  imports = [ inputs.copyparty.nixosModules.default ];

  nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

  # age.secrets.jeffrey-passwordfile.file = ../secrets/jeffrey/passwordfile.age;
  age.secrets.copyparty-jeffrey-passwordfile = {
    file = ../../secrets/uxie/copyparty/jeffrey-passwordfile.age;
    owner = config.services.copyparty.user;
    group = config.services.copyparty.group;
  };

  services.copyparty = {
    enable = true;

    settings = {
      i = "0.0.0.0";
      p = 3210;
      usernames = true;
    };

    accounts.jeffrey.passwordFile = config.age.secrets.copyparty-jeffrey-passwordfile.path;

    volumes = {
      "/public" = {
        path = "/mnt/main-pool/public";

        access = {
          r = "*";
          A = "jeffrey";
        };
      };

      "/" = {
        path = "/mnt/main-pool/srv";

        access = {
          r = "*";
        };
      };

      "/jeffrey" = {
        path = "/mnt/main-pool/users/jeffrey";

        access = {
          A = "jeffrey";
        };
      };

      "/media" = {
        path = "/mnt/main-pool/media";

        access = {
          A = "jeffrey";
        };
      };
    };
  };

  services.samba = {
  enable = true;

  settings = {
  media = {
  path = "/mnt/main-pool/media";
  "valid users" = "jeffrey";
  public = false;
  writable = true;
  };

  time-machine = {
  path = "/mnt/main-pool/backups/macOS";
  "valid users" = "jeffrey";
  public = false;
  writeable = true;
  "force user" = "jeffrey";
  "fruit:aapl" = true;
  "fruit:time machine" = true;
  "vfs objects" = "catia fruit streams_xattr";
  };
  
  homes = {
  path = "/mnt/main-pool/users-share/%S";
  "valid users" = "%S";
  "create mask" = "0700";
  "directory mask" = "0700";
  browseable = false;
  public = false;
  writeable = true;
  };
  };
  };
}
