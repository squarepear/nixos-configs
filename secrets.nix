let
  info = import ./hosts/info.nix;

  jeffrey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyZWg5m3pXHOqNfdrO6ecghFfQowb/Y7Df7otocETHq";

  users = [ jeffrey ];

  hosts = builtins.mapAttrs (_: host: host.publicKey) info;

  allHosts = builtins.attrValues hosts;
in
{
  "secrets/test-secret.age".publicKeys = users ++ allHosts;

  # User Specific
  "secrets/jeffrey/passwordfile.age".publicKeys = [ jeffrey ] ++ allHosts;

  # Lab Specific
  "secrets/lab/miniflux-admin.age".publicKeys = [
    jeffrey
    hosts.tepig
  ];

  "secrets/lab/cloudflare-creds.age".publicKeys = [
    jeffrey
    hosts.uxie
  ];

  "secrets/lab/glance-env.age".publicKeys = [
    jeffrey
    hosts.uxie
  ];

  "secrets/lab/copyparty/jeffrey-passwordfile.age".publicKeys = [
    jeffrey
    hosts.uxie
  ];

  "secrets/lab/searxng-env.age".publicKeys = [
    jeffrey
    hosts.uxie
  ];
}
