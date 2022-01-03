{ config, lib, pkgs, ... }:

{
  # Enable sway
  programs.sway.enable = config.system.gui.enable;

  # Enable wayland screen sharing
  xdg.portal.wlr.enable = config.system.gui.enable;

  # Enable swaylock password authentication
  security.pam.services.swaylock = { };

  # Text UI greeter
  services.greetd = {
    enable = config.system.gui.enable;
    package = pkgs.greetd.tuigreet;

    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -tr --asterisks --greeting \"This legendary Pokémon can scorch the world with fire. It helps those who want to build a world of truth.\" --cmd sway";
  };

  systemd.services.greetd = lib.mkIf config.system.gui.enable {
    unitConfig = {
      After = lib.mkOverride 0 [ "multi-user.target" ];
    };
    serviceConfig = {
      Type = "idle";
    };
  };

  # Greeter group
  users = lib.mkIf config.system.gui.enable {
    users.greeter.group = "greeter";
    groups.greeter = { };
  };
}
