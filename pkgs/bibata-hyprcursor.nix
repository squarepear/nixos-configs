{ lib, stdenvNoCC, fetchurl, ... }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-hyprcursor";

  version = "1.0";

  src = fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/1.0/hypr_Bibata-Modern-Classic.tar.gz";
    hash = "sha256-+ZXnbI3bBLcb0nv2YW3eM/tK4dsraNM4UAO9BpSqfXk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/Bibata-Modern-Classic-hyprcursor
    cp -r ../hyprcursors $out/share/icons/Bibata-Modern-Classic-hyprcursor/
    cp ../manifest.hl $out/share/icons/Bibata-Modern-Classic-hyprcursor/
    
    # Replace the name in manifest.hl
    substituteInPlace $out/share/icons/Bibata-Modern-Classic-hyprcursor/manifest.hl \
      --replace "name = Bibata-Modern-Classic" "name = Bibata-Modern-Classic-hyprcursor"

    runHook postInstall
  '';

  meta = {
    description = "Open source, compact, and material designed cursor set";
    homepage = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
