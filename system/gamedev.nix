{ pkgs, ... }:

{
  my.home.packages = with pkgs; [
    # Game Engines
    godot_4

    # Art
    blender-hip
    aseprite-unfree
    krita
    inkscape
    gimp

    # Audio
    lmms
    audacity

    # Other
    logseq # Note taking and planning
  ];

  # ROCm/HIP
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
