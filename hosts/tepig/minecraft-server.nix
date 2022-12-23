{ pkgs, config, ... }:

let

  serverPath = "/home/${config.user.name}/harmon_family_game_servers/mc_vanilla++";

in
{
  systemd.services = {
    "vpp-minecraft" = {
      description = "Vanilla++ Minecraft Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "vpp-packwiz.service" ];
      requires = [ "vpp-packwiz.service" ];

      serviceConfig = {
        Type = "forking";
        ExecStartPre = "-${pkgs.tmux}/bin/tmux kill-session -t vpp-minecraft";
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s vpp-minecraft 'server/launch.sh'";
        WorkingDirectory = serverPath;

        User = "${config.user.name}";
        Group = "users";
      };

      path = with pkgs; [
        tmux
        temurin-bin
        minecraft-server-hibernation
      ];
    };

    "vpp-packwiz" = {
      description = "Vanilla++ Packwiz Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.packwiz}/bin/packwiz serve --port 23333";
        WorkingDirectory = "${serverPath}/modpack";

        User = "${config.user.name}";
        Group = "users";
      };

      path = with pkgs; [
        packwiz
      ];
    };
  };
}
