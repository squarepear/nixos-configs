{
  pkgs,
  lib,
  kernel,
}:

pkgs.callPackage ./mk-kernel-module.nix {
  inherit kernel;
  pname = "amdgpu-kernel-module";
  modulePath = "drivers/gpu/drm/amd/amdgpu";
  patches = [
    (pkgs.fetchpatch {
      name = "cap_sys_nice_begone.patch";
      url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
      hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    })
  ];
  meta = {
    description = "AMD GPU kernel module";
    license = lib.licenses.gpl3;
  };
}
