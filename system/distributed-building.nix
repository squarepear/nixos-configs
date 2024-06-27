{ config, ... }:

{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "reshiram";
        speedFactor = 16;
        sshKey = "/home/${config.pear.user.name}/.ssh/id_ed25519";
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      }

      {
        hostName = "altaria";
        speedFactor = 4;
        sshKey = "/home/${config.pear.user.name}/.ssh/id_ed25519";
        systems = [
          "aarch64-linux"
        ];
      }
    ];
  };
}
