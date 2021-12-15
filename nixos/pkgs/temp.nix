{ config, pkgs, ... }:
{
  # Boot configuration
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];

  # User accounts
  users.users.owner = {
    extraGroups = [ "libvirtd" ];
  };

  # Enable libvirtd
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemuOvmf = true;
    qemuRunAsRoot = true;
  };

  # Add binaries to path so that hooks can use it
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
            ripgrep
            sd
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

  # Enable xrdp
  services.xrdp.enable = true; # use remote_logout and remote_unlock
  services.xrdp.defaultWindowManager = "i3";
  systemd.services.pcscd.enable = false;
  systemd.sockets.pcscd.enable = false;

  # VFIO Packages installed
  environment.systemPackages = with pkgs; [
    virt-manager
    gnome3.dconf # needed for saving settings in virt-manager
    libguestfs # needed to virt-sparsify qcow2 files
  ];

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
          VIRSH_GPU_VIDEO=pci_0000_01_00_0
          VIRSH_GPU_AUDIO=pci_0000_01_00_1
        '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
      text =
        ''
          #!/run/current-system/sw/bin/bash

          # Debugging
          # exec 19>/home/owner/Desktop/startlogfile
          # BASH_XTRACEFD=19
          # set -x

          # Load variables we defined
          source "/etc/libvirt/hooks/kvm.conf"

          # Change to performance governor
          echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

          # Isolate host to core 0
          systemctl set-property --runtime -- user.slice AllowedCPUs=0
          systemctl set-property --runtime -- system.slice AllowedCPUs=0
          systemctl set-property --runtime -- init.scope AllowedCPUs=0

          # Logout
          source "/home/owner/Desktop/Sync/Files/Tools/logout.sh"

          # Stop display manager
          systemctl stop display-manager.service

          # Unbind VTconsoles
          echo 0 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind

          # Unbind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

          # Avoid race condition
          # sleep 5

          # Unload NVIDIA kernel modules
          modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

          # Detach GPU devices from host
          virsh nodedev-detach $VIRSH_GPU_VIDEO
          virsh nodedev-detach $VIRSH_GPU_AUDIO

          # Load vfio module
          modprobe vfio-pci
        '';
      mode = "0755";
    };

    "libvirt/hooks/qemu.d/win10/release/end/stop.sh" = {
      text =
        ''
          #!/run/current-system/sw/bin/bash

          # Debugging
          # exec 19>/home/owner/Desktop/stoplogfile
          # BASH_XTRACEFD=19
          # set -x

          # Load variables we defined
          source "/etc/libvirt/hooks/kvm.conf"

          # Unload vfio module
          modprobe -r vfio-pci

          # Attach GPU devices from host
          virsh nodedev-reattach $VIRSH_GPU_VIDEO
          virsh nodedev-reattach $VIRSH_GPU_AUDIO

          # Read nvidia x config
          nvidia-xconfig --query-gpu-info > /dev/null 2>&1

          # Load NVIDIA kernel modules
          modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

          # Avoid race condition
          # sleep 5

          # Bind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

          # Bind VTconsoles
          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 1 > /sys/class/vtconsole/vtcon1/bind

          # Start display manager
          systemctl start display-manager.service

          # Return host to all cores
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-3
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-3
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-3

          # Change to powersave governor
          echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
        '';
      mode = "0755";
    };

    "libvirt/vgabios/patched.rom".source = /home/owner/Desktop/Sync/Files/Linux_Config/symlinks/patched.rom;
  };
} 
