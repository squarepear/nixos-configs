{
  config,
  lib,
  pearlib,
  pkgs,
  ...
}:

let
  cfg = config.pear.services.ssh;
in
{
  options.pear.services.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = pearlib.profileEnabled "minimal";
    };

    fail2ban = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = pearlib.profileEnabled "server";
        description = "Enable fail2ban for sshd.";
      };

      ignoreIP = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "100.64.0.0/10" ];
        description = "IP ranges to ignore for bans (e.g. tailscale CGNAT range).";
      };

      banTime = lib.mkOption {
        type = lib.types.str;
        default = "31d";
      };

      enableNtfyAction = lib.mkOption {
        type = lib.types.bool;
        default = pearlib.profileEnabled "server";
        description = "Install a fail2ban action that sends ban notifications to an ntfy topic.";
      };

      ntfyUrl = lib.mkOption {
        type = lib.types.str;
        default = "https://ntfy.hl.pear.cx/fail2ban";
        description = "The ntfy topic URL to post ban notifications to (only used when enableNtfyAction = true).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenSSH
    services.openssh = {
      enable = true;

      # Disable password authentication
      settings = {
        PasswordAuthentication = false;
        LoginGraceTime = 0;
      };
    };

    services.fail2ban = lib.mkIf cfg.fail2ban.enable {
      enable = true;
      ignoreIP = cfg.fail2ban.ignoreIP;
      extraPackages = [ pkgs.ipset ];
      bantime = cfg.fail2ban.banTime;
      banaction = "iptables-ipset-proto6-allports";

      jails.sshd.settings = lib.mkIf cfg.fail2ban.enableNtfyAction {
        action = ''
          %(action_)s[blocktype=DROP]
                       ntfy'';
      };
    };

    environment.etc = lib.mkIf cfg.fail2ban.enableNtfyAction {
      # Define an action that will trigger a Ntfy push notification upon every new ban.
      "fail2ban/action.d/ntfy.local".text = lib.mkDefault (
        lib.mkAfter ''
          [Definition]
          norestored = true # Needed to avoid receiving a new notification after every restart
          actionban = ${lib.getExe pkgs.curl} -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(${lib.getExe pkgs.hostname}) after <failures> attempts." ${cfg.fail2ban.ntfyUrl}
        ''
      );
    };

    pear.system.impermanence.users = pearlib.perUser (name: {
      persist.directories = [
        ".ssh"
      ];
    });
  };
}
