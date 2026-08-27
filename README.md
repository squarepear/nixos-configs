<div align="center">
    <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" width="128" height="128" alt="NixOS Logo">
    <h1><a href="https://github.com/squarepear/nixos-configs">squarepear/nixos-configs</a></h1>
    <p>Personal NixOS configurations for multiple hosts with shared modules and packages</p>
</div>

## [Hosts](./hosts/)

- [**reshiram**](./hosts/reshiram/) - Main Desktop (x86_64-linux)
  - Gaming rig with AMD CPU/GPU, Niri, development environment
- [**tepig**](./hosts/tepig/) - Raspberry Pi 4b 8G (aarch64-linux)
  - Home automation (Home Assistant), notification server (ntfy), and more
- [**uxie**](./hosts/uxie/) - NAS Server (x86_64-linux)
  - Media server (Jellyfin), photo management (Immich), file sharing (Copyparty/SMB), dashboard (Glance), reverse proxy (Traefik), and more

## Structure

```
├── flake.nix       # Main flake configuration
├── hosts/          # Host-specific configurations
├── lib/            # Shared helper modules
├── modules/        # Reusable NixOS modules (system, programs, desktop, lab, ...)
├── pkgs/           # Custom package definitions
├── secrets/        # Encrypted secrets (agenix)
└── secrets.nix     # Secret public keys
```
