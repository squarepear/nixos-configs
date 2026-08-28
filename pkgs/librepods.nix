{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  alsa-lib,
  bluez,
  dbus,
  expat,
  fontconfig,
  freetype,
  libGL,
  libpulseaudio,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  wayland,
  vulkan-loader,
  ...
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "librepods";
  version = "unstable-2026-08-27";

  src = fetchFromGitHub {
    owner = "librepods-org";
    repo = "librepods";
    rev = "672e65ad36eebf21ff1c1a508066f9197ee56d17";
    hash = "sha256-EuIYvBqBtpgutVqPOLIO3E9OhVzQ5q5TDoz/F+9MHEE=";
  };

  sourceRoot = "source/linux-rust";

  cargoLock.lockFile = "${finalAttrs.src}/linux-rust/Cargo.lock";
  # If Nix prints `got: sha256-…` on build failure, paste it as `cargoHash = "sha256-…";`.
  cargoHash = "";

  buildInputs = [
    alsa-lib
    bluez
    dbus
    expat
    fontconfig
    freetype
    libGL
    libpulseaudio
    libxkbcommon
    libxrandr
    wayland
    libxcursor
    libxi
    libx11
    vulkan-loader
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    wrapProgram $out/bin/librepods \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
  '';

  meta = {
    description = "AirPods liberated from Apple's ecosystem (Rust/iced app)";
    homepage = "https://github.com/librepods-org/librepods";
    license = lib.licenses.gpl3Only;
    mainProgram = "librepods";
    platforms = lib.platforms.linux;
  };
})
