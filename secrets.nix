let
  info = import ./hosts/info.nix;

  jeffrey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyZWg5m3pXHOqNfdrO6ecghFfQowb/Y7Df7otocETHq";

  users = [ jeffrey ];

  reshiram = info.reshiram.publicKey;
  tepig = info.tepig.publicKey;
  uxie = info.uxie.publicKey;

  hosts = [
    reshiram
    tepig
    uxie
  ];
in
{
  "secrets/test-secret.age".publicKeys = users ++ hosts;

  # User Specific
  "secrets/jeffrey/passwordfile.age".publicKeys = [ jeffrey ] ++ hosts;

  # Lab Specific
  "secrets/lab/miniflux-admin.age".publicKeys = [
    jeffrey
    tepig
  ];

  "secrets/lab/cloudflare-creds.age".publicKeys = [
    jeffrey
    uxie
  ];

  "secrets/lab/glance-env.age".publicKeys = [
    jeffrey
    uxie
  ];

  "secrets/lab/copyparty/jeffrey-passwordfile.age".publicKeys = [
    jeffrey
    uxie
  ];

  "secrets/lab/searxng-env.age".publicKeys = [
    jeffrey
    uxie
  ];
}
