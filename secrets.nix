let
  jeffrey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyZWg5m3pXHOqNfdrO6ecghFfQowb/Y7Df7otocETHq";

  users = [ jeffrey ];

  altaria = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwtSK+fzHcdehRsrYSz/fqfiKvSQ9P6NZTUVwRKR9za";
  reshiram = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0BJ8FAFBISvFH60tAE+gYk84Qq3Q1lV6uxek0E+DLw";
  tepig = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNS2qVtpFUJqZYhrqtbaIXa9TgCvYQiQtf47tXM1iP0";
  uxie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7dRYCqWEzF4OUABaid16HXrzVvUx8YMii/FdSdOXvj";

  hosts = [ altaria reshiram tepig uxie ];
in
{
  "secrets/test-secret.age".publicKeys = users ++ hosts;

  # User Specific
  "secrets/jeffrey/passwordfile.age".publicKeys = [ jeffrey ] ++ hosts;

  # Host Specific
  "secrets/tepig/cloudflare-creds.age".publicKeys = [ jeffrey tepig ];
}
