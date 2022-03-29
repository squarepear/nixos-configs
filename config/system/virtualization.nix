{ config, pkgs, ... }:

{
  # Enable libvirtd
  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_rw_perms = "0770"
      log_filters="1:qemu"
      log_outputs="1:file:/var/log/libvirt/libvirtd.log"
    '';

    onBoot = "ignore";
    onShutdown = "shutdown";

    qemu = {
      ovmf.enable = true;
      # runAsRoot = false;

      verbatimConfig = ''
        user = "jeffrey"
        group = "users"
      '';
    };
  };

  # Add libvirtd group
  users.users.jeffrey = {
    extraGroups = [ "libvirtd" "kvm" ];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    libguestfs
  ];

  programs.dconf.enable = true; # Needed for saving settings in virt-manager

  #
  #  VFIO single GPU passthrough options
  #

  # Boot configuration
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "video=efifb:off" ];
  boot.kernelModules = [ "kvm-amd" ];

  # Link hooks to the correct directory
  system.activationScripts.libvirt-hooks.text = ''
    ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
  '';

  # enable access from hooks to bash, modprobe, systemctl, etc
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            killall
          ];
        };
      in
      [ env ];
  };

  environment.etc = {
    "libvirt/hooks/qemu" = {
      text =
        ''
          #!/run/current-system/sw/bin/bash
          #
          # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
          #
          # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
          # After this file is installed, restart libvirt.
          # From now on, you can easily add per-guest qemu hooks.
          # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
          # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
          #

          GUEST_NAME="$1"
          HOOK_NAME="$2"
          STATE_NAME="$3"
          MISC="''${@:4}"

          BASEDIR="$(dirname $0)"

          HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

          set -e # If a script exits with an error, we should as well.

          # check if it's a non-empty executable file
          if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
              eval \"$HOOKPATH\" "$@"
          elif [ -d "$HOOKPATH" ]; then
              while read file; do
                  # check for null string
                  if [ ! -z "$file" ]; then
                    eval \"$file\" "$@"
                  fi
              done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
          fi
        '';
      mode = "0755";
    };

    "libvirt/hooks/kvm.conf" = {
      text =
        ''
          VIRSH_GPU_VIDEO=pci_0000_0B_00_0
          VIRSH_GPU_AUDIO=pci_0000_0B_00_1
        '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
      text =
        ''
          #!/run/current-system/sw/bin/bash

          # Debugging
          exec 19>/home/owner/Desktop/startlogfile
          BASH_XTRACEFD=19
          set -x

          echo "Beginning of startup"

          # Stop display manager
          killall sway

          echo "End of startup"
        '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/release/end/stop.sh" = {
      text =
        ''
          #!/run/current-system/sw/bin/bash

          # Debugging
          exec 19>/home/owner/Desktop/stoplogfile
          BASH_XTRACEFD=19
          set -x

          echo "Beginning of teardown"

          # Start display manager
          sway

          echo "End of teardown"
        '';
      mode = "0755";
    };
  };
}
