{ ... }:

{
  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.hl.pear.cx";
      upstream-base-url = "https://ntfy.sh";
      listen-http = ":8585";
      behind-proxy = true;
    };
  };
}
