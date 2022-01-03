{ pkgs, ... }:

{
  services.k3s.enable = true;

  # k3s cgroup support 
  boot.kernelParams = [ "cgroup_memory=1" "cgroup_enable=memory" ];
}