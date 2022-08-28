{ config, ... }:

{
  nix = {
    distributedBuilds = false;

    buildMachines = [
      {
        hostName = "reshiram";
        speedFactor = 12;
        sshUser = "jeffrey";
        sshKey = "/home/${config.user.name}/.ssh/id_ed25519";
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
      }

      # {
      #   hostName = "genesect";
      #   speedFactor = 6;
      #   sshUser = "jeffrey";
      #   sshKey = "/home/jeffrey/.ssh/id_ed25519";
      #   systems = [
      #     "aarch64-linux"
      #     "x86_64-linux"
      #   ];
      # }
    ];
  };
}
