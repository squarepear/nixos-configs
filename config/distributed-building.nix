{ config, ... }:

{
  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "reshiram";
        speedFactor = 12;
        sshUser = "jeffrey";
        sshKey = "/home/${config.user.name}/.ssh/id_ed25519";
        systems = [
          "x86_64-linux"
        ];
      }

      {
        hostName = "altaria";
        speedFactor = 4;
        sshUser = "jeffrey";
        sshKey = "/home/${config.user.name}/.ssh/id_ed25519";
        systems = [
          "aarch64-linux"
        ];
      }
    ];
  };
}
