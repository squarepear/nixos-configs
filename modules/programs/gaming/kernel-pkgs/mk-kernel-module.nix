{
  pkgs,
  lib,
  kernel,
  pname,
  modulePath,
  patches ? [ ],
  postPatch ? (kernel.postPatch or ""),
  extraMakeFlags ? "",
  meta ? { },
}:

# Build a single in-tree kernel module out-of-tree against `kernel`, so it lands
# under `updates/` and shadows the in-tree copy without a full kernel rebuild.
pkgs.stdenv.mkDerivation {
  inherit
    pname
    patches
    postPatch
    modulePath
    ;
  inherit (kernel)
    src
    version
    nativeBuildInputs
    ;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  buildPhase = ''
    runHook preBuild

    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare

    make "-j$NIX_BUILD_CORES" \
      M=$modulePath \
      ${extraMakeFlags} \
      modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install

    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  }
  // meta;
}
