{ ... }:

{
  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.hl.pear.cx";
      listen-http = ":8585";
      behind-proxy = true;
    };
  };
}
