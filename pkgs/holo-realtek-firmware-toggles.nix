{
  lib,
  stdenvNoCC,
  fetchurl,
  coreutils,
  findutils,
  gnugrep,
  iw,
  writeText,
  ...
}:

let
  # Commands the script needs once it has re-executed itself as root. pkexec
  # resets PATH to a minimal value, so the script has to restore these itself.
  runtimePath = lib.makeBinPath [
    coreutils
    findutils
    gnugrep
    iw
  ];

  # Inserted after the shebang: restores PATH for the pkexec re-exec, and adds
  # the one form of `compgen` the script uses (`compgen -G <glob>`), which Nix's
  # bash does not provide as it lacks programmable completion.
  prelude = writeText "holo-realtek-firmware-toggles-prelude.sh" ''
    export PATH=${runtimePath}:/run/wrappers/bin''${PATH:+:$PATH}

    compgen() {
      if [ "''${1:-}" = "-G" ]; then
        for f in ''${2:-}; do echo "$f"; done
        return 0
      fi
      return 1
    }
  '';
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "holo-realtek-firmware-toggles";
  version = "1.4-1";

  src = fetchurl {
    url = "https://steamdeck-packages.steamos.cloud/archlinux-mirror/sources/holo-main/${finalAttrs.pname}-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-2Z7ZwQhBSV6grizYkZZpw1758i5j9QJZ74kUxIf0J/A=";
  };

  sourceRoot = "holo-realtek-firmware-toggles";

  dontConfigure = true;
  dontBuild = true;

  # The script re-runs itself through pkexec to gain root, which wipes the
  # environment, so PATH and the compgen shim are injected ahead of its own code.
  postPatch = ''
    sed -i "1r ${prelude}" holo-realtek-firmware-toggles
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 holo-realtek-firmware-toggles \
      $out/bin/holo-realtek-firmware-toggles

    install -Dm0644 org.valve.holo-realtek-firmware-toggles.policy \
      $out/share/polkit-1/actions/org.valve.holo-realtek-firmware-toggles.policy

    # The upstream policy points at a SteamOS-specific helper path. pkexec
    # matches the action by the canonical path of the executed program, so it
    # has to reference the store path of the script instead.
    substituteInPlace $out/share/polkit-1/actions/org.valve.holo-realtek-firmware-toggles.policy \
      --replace-fail '/usr/bin/holo-polkit-helpers/holo-realtek-firmware-toggles' \
      "$out/bin/holo-realtek-firmware-toggles"

    runHook postInstall
  '';

  meta = {
    description = "Tool to toggle realtek rtw89 driver bits (used by the Steam Frame wireless adapter)";
    homepage = "https://gitlab.steamos.cloud/holo/holo";
    license = lib.licenses.mit;
    mainProgram = "holo-realtek-firmware-toggles";
    platforms = lib.platforms.linux;
  };
})
