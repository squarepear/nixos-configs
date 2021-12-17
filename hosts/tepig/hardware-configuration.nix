{ ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  fileSystems."/cluster-nfs" =
    { device = "/dev/disk/by-uuid/d4d0f63e-cd6c-4947-8b81-bae9322877d9";
      fsType = "ext4";
    };
}
