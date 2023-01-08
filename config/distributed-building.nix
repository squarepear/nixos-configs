{ config, ... }:

{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "reshiram";
        speedFactor = 12;
        sshKey = "/home/${config.user.name}/.ssh/id_ed25519";
        systems = [
          "x86_64-linux"
        ];
      }

      {
        hostName = "altaria";
        speedFactor = 4;
        sshKey = "/home/${config.user.name}/.ssh/id_ed25519";
        systems = [
          "aarch64-linux"
        ];
      }
    ];
  };
}
