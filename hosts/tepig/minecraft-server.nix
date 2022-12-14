{ pkgs, ... }:

{
  my = {
    systemd.user.services = {
      "vpp.minecraft" = {
        Unit = {
          Description = "Vanilla++ Minecraft Server";
          After = [ "network.target" "vpp.packwiz.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.minecraft-server-hibernation}/bin/msh";
          WorkingDirectory = "/home/jeffrey/harmon_family_game_servers/mc_vanilla++";
        };
      };

      "vpp.packwiz" = {
        Unit = {
          Description = "Vanilla++ Packwiz Server";
          After = [ "network.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.packwiz}/bin/packwiz serve";
          WorkingDirectory = "/home/jeffrey/harmon_family_game_servers/mc_vanilla++/modpack";
        };
      };
    };
  };
}
