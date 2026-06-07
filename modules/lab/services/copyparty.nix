{
  config,
  lib,
  inputs,
  pearlib,
  ...
}:

let
  cfg = config.pear.lab.service.copyparty;
in
{
  imports = [ inputs.copyparty.nixosModules.default ];

  options.pear.lab.service.copyparty = {
    enable = lib.mkEnableOption "copyparty file server";
  };

  config = lib.mkMerge [
    {
      pear.lab.proxyRoutes.copyparty = {
        subdomain = "nas";
        port = 3210;
      };
    }
    (lib.mkIf cfg.enable {
      nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

      age.secrets.lab-copyparty-jeffrey-passwordfile = {
        file = ../../../secrets/lab/copyparty/jeffrey-passwordfile.age;
        owner = config.services.copyparty.user;
        group = config.services.copyparty.group;
      };

      services.copyparty = {
        enable = true;

        settings = {
          i = "0.0.0.0";
          p = 3210;
          usernames = true;
          rproxy = -1;
          xff-src = "${pearlib.ipForService "reverse-proxy"}/32";
        };

        accounts.jeffrey.passwordFile = config.age.secrets.lab-copyparty-jeffrey-passwordfile.path;

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

      networking.firewall = {
        allowedTCPPorts = [
          445
          139
        ];
        allowedUDPPorts = [
          137
          138
        ];
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
    })
  ];
}
