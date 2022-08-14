{ pkgs, ... }:

{
  # For network discovery of printers
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ brlaser gutenprint ];
}
