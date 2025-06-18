<div align="center">
    <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" width="128" height="128" alt="NixOS Logo">
    <h1><a href="https://github.com/squarepear/nixos-configs">squarepear/nixos-configs</a></h1>
    <p>Personal NixOS configurations for multiple hosts with shared modules and packages</p>
</div>

## 🏠 [Hosts](./hosts/)

- [**altaria**](./hosts/altaria/) - Oracle Cloud ARM Server (aarch64-linux)
  - Minecraft server, containers, distributed building
- [**reshiram**](./hosts/reshiram/) - Main Desktop (x86_64-linux)
  - Gaming rig with AMD CPU/GPU, Hyprland, development environment
- [**tepig**](./hosts/tepig/) - Raspberry Pi 4b 8G (aarch64-linux)
  - Home automation, monitoring, reverse proxy, RSS feeds
- [**uxie**](./hosts/uxie/) - NAS Server (x86_64-linux)
  - Media server (Jellyfin), photo management (Immich), SMB shares
- [**kyurem**](./hosts/kyurem/) - macOS (darwin)

## 📁 Structure

```
├── hosts/          # Host-specific configurations
├── system/         # Reusable system modules
├── users/          # User configurations
├── modules/        # Custom NixOS modules
├── pkgs/           # Custom package definitions
├── secrets/        # Encrypted secrets (agenix)
├── darwin/         # macOS-specific configurations
└── flake.nix       # Main flake configuration
```

## 📝 Notes

- Auto-upgrade is enabled and pulls from this repository
- Configurations use NixOS unstable for latest packages
- Distributed building configured between hosts
- Home Manager manages user-specific dotfiles and packages
