{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qmk
    via
  ];

  hardware.keyboard.qmk.enable = true;

  # Allow control of keyboard with VIA (https://wiki.archlinux.org/title/Keyboard_input#Configuration_of_VIA_compatible_keyboards)
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
  '';
}
