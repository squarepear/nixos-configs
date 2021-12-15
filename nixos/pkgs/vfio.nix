{ config, pkgs, ... }:

{
  # Boot configuration
  boot.kernelParams = [
    # Enable IOMMU
    "amd_iommu=on"
    "iommu=pt"
  ];

  boot.initrd.kernelModules = [ "kvm-amd" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  # Add libvirtd group
  users.users.jeffrey = {
    extraGroups = [ "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    libguestfs # Needed to virt-sparsify qcow2 files
  ];

  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #     vendor-reset # Needed to allow AMD GPUs to be passed to VM using VFIO
  # ];

  programs.dconf.enable = true; # Needed for saving settings in virt-manager

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

      verbatimConfig = ''
        user = "jeffrey"
        users = "users"
      '';
    };
  };

  # Add binaries to path so that hooks can use it
  systemd.services.libvirtd = {
    path =
      let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            pciutils
            killall
            util-linux
            kmod
            libvirt
          ];
        };
      in
      [ env ];
  };

  # Link hooks to the correct directory
  system.activationScripts.libvirt-hooks.text =
    ''
      ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
    '';

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
          VIRSH_GPU_VIDEO=pci_0000_06_00_0
          VIRSH_GPU_AUDIO=pci_0000_06_00_1
          GPU_VIDEO=0000:06:00.0
          GPU_AUDIO=0000:06:00.1
        '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
      text =
        ''
          # Debugging
          set -x

          # Load variables we defined
          source "/etc/libvirt/hooks/kvm.conf"

          # Stop display manager
          killall sway

          # Avoid race condition
          sleep 5

          # Unbind VTconsoles if currently bound (adapted from https://www.kernel.org/doc/Documentation/fb/fbcon.txt)
          if test -e "/tmp/vfio-bound-consoles" ; then
              rm -f /tmp/vfio-bound-consoles
          fi

          for (( i = 0; i < 16; i++))
          do
              if test -x /sys/class/vtconsole/vtcon$\{i}; then
                  if [ `cat /sys/class/vtconsole/vtcon$\{i}/name | grep -c "frame buffer"` \
                      = 1 ]; then
                      echo 0 > /sys/class/vtconsole/vtcon$\{i}/bind
                      echo "Unbinding console $\{i}"
                      echo $i >> /tmp/vfio-bound-consoles
                  fi
              fi
          done

          # # Unload amdgpu
          # modprobe -r amdgpu
          
          # # Detach GPU devices from host
          # virsh nodedev-detach $VIRSH_GPU_VIDEO
          # virsh nodedev-detach $VIRSH_GPU_AUDIO

          # # Load vfio
          # modprobe vfio
          # modprobe vfio_pci
          # modprobe vfio_iommu_type1

          echo "Start Done"
        '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/release/end/stop.sh" = {
      text =
        ''
          # Debugging
          set -x

          # Load variables we defined
          source "/etc/libvirt/hooks/kvm.conf"

          # Rebind VT consoles (adapted from https://www.kernel.org/doc/Documentation/fb/fbcon.txt)
          input="/tmp/vfio-bound-consoles"
          while read consoleNumber; do
              if test -x /sys/class/vtconsole/vtcon$\{consoleNumber}; then
                  if [ `cat /sys/class/vtconsole/vtcon$\{consoleNumber}/name | grep -c "frame buffer"` \
                      = 1 ]; then
                  echo "Rebinding console $\{consoleNumber}"
                  echo 1 > /sys/class/vtconsole/vtcon$\{consoleNumber}/bind
                  fi
              fi
          done < "$input"

          echo "Stop Done"
        '';
      mode = "0755";
    };
  };

  # systemd.services = {
  #     "libvirt-nosleep@" = {
  #         description = "Preventing sleep while libvirt domain \"%i\" is running";
  #         unitConfig = {
  #             Type = "simple";
  #         };
  #         serviceConfig = {
  #             ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=sleep --why='Libvirt domain \"%i\" is running' --who=%U --mode=block sleep infinity";
  #         };
  #     };
  # };
}
