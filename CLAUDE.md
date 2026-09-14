# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a WSL Gentoo setup repository using **mitamae** (mruby-based provisioning tool) for system configuration management. The setup is divided into two main phases:

1. **System configuration** (`system.rb`) - Runs with sudo privileges
2. **User configuration** (`user.rb`) - Runs as regular user

### Key Components

- **mitamae**: Provisioning tool downloaded to `bin/mitamae` (version 1.14.0)
- **Platform detection**: Automatically detects platform (Gentoo/Arch) and includes appropriate recipes
- **Recipe structure**: 
  - `system/[platform]/default.rb` - Platform-specific system packages and configs
  - `user/[component]/default.rb` - User-level component configurations
  - Configuration files stored in `*/files/` subdirectories

## Common Commands

### Initial Setup
```bash
# Download and setup mitamae binary
bin/setup

# Apply system configuration (requires sudo)
sudo bin/mitamae local system.rb

# Apply user configuration (run as regular user)
bin/mitamae local user.rb
```

### Development
```bash
# Test system configuration changes
sudo bin/mitamae local system.rb

# Test user configuration changes  
bin/mitamae local user.rb

# Test specific recipe
bin/mitamae local -o user/fish/default.rb
```

## Platform Support

- **Gentoo**: Primary platform using emerge/portage
- **Arch**: Secondary platform using pacman/paru

Platform detection happens automatically via `node[:platform]` in mitamae recipes.

### Docker

Gentoo runs Docker rootless (`system/gentoo/03_docker.rb` + `user/docker/`). It lives under `system/gentoo/` rather than `system/docker/` because Arch would build rootless from the AUR's `docker-rootless-extras`, which ships the systemd unit that Gentoo has to deploy by hand. `system/docker/` is the rootful recipe; only Arch uses it.

Things that look redundant but are not:

- `/etc/systemd/user/docker.service` is hand-deployed: portage ships `dockerd-rootless.sh` but not the unit. Do not add a `docker.socket`; it would collide with the socket `dockerd-rootless.sh` opens itself.
- `modules-load.d/docker.conf` exists because a user service cannot modprobe `ip_tables`/`overlay`.
- The subordinate UID/GID range is reserved only when the user has none. Changing an existing range orphans everything under `~/.local/share/docker`.
- `user/docker/` deletes `~/.config/systemd/user/docker.service`, which would shadow the managed unit.
- `fuse-overlayfs` is deliberately absent; the host uses the native overlay2 driver.

## Configuration Management

- Keep code comments minimal: only concise decision rationale that the code cannot express, such as why an alternative is not used. Put what/how explanations in commit messages.

- System files are templated in `system/[component]/files/`
- User dotfiles managed via `user/dotfiles/` using `mise dotfiles apply`
- Arch installs mise from the AUR `mise-bin` package; on Gentoo, `user/mise/` installs mise and adds `~/.local/bin` to the provisioning PATH. Dotfiles recipes invoke `mise` through PATH on both platforms
- All configurations are declarative through mitamae recipes
