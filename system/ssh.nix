{ config, lib, pkgs, ... }:

{
  # Enable OpenSSH
  services.openssh = {
    enable = true;

    # Disable password authentication
    settings = {
      PasswordAuthentication = false;
      LoginGraceTime = 0;
    };
  };

  programs.ssh.extraConfig = ''
    Host *
      ConnectTimeout 3
  '';

  users.users.root.openssh.authorizedKeys.keys = [
    config.pear.user.publickey
  ];

  services.fail2ban = {
    enable = true;

    ignoreIP = [
      "100.64.0.0/10"
    ];

    extraPackages = [ pkgs.ipset ];
    bantime = "7d";
    banaction = "iptables-ipset-proto6-allports";

    jails.sshd.settings = {
      action = ''%(action_)s[blocktype=DROP]
                 ntfy'';
    };
  };

  environment.etc = {
    # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
    "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      norestored = true # Needed to avoid receiving a new notification after every restart
      actionban = ${lib.getExe pkgs.curl} -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(${lib.getExe pkgs.hostname}) after <failures> attempts of hacking the system." https://ntfy.hl.pear.cx/fail2ban
    '');
  };
}
