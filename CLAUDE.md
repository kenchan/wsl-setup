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

Gentoo runs Docker rootless, in `system/gentoo/03_docker.rb` plus
`user/docker/`. It sits under the platform directory because the two
distributions assemble rootless mode differently: Gentoo builds it from portage
packages and hand-deployed units, while Arch would pull in the AUR's
`docker-rootless-extras`, which ships those units itself. `system/docker/`
remains the rootful recipe Arch still uses.

The daemon is a systemd user service, so the system recipe reserves a
subordinate UID/GID range, enables lingering and disables the system-wide
daemon, while `user/docker/` enables the user service and points a `rootless`
docker context at `$XDG_RUNTIME_DIR/docker.sock`, which the CLI does not probe
on its own.

The subordinate range is only reserved when the user has none. Rewriting an
existing range would orphan everything already stored under
`~/.local/share/docker`.

Portage ships `dockerd-rootless.sh` inside `app-containers/docker` but not the
user unit that `dockerd-rootless-setuptool.sh` would generate, so that comes from
`system/gentoo/files/etc/systemd/user/`. Only `docker.service` -- upstream has no
`docker.socket` for rootless, and one bound to the same path would collide with
the socket `dockerd-rootless.sh` opens itself.

`/etc/modules-load.d/docker.conf` loads `ip_tables` and `overlay` at boot. The
rootful daemon modprobes them itself, but a user service has no permission to.

`user/docker/` deletes a hand-written `~/.config/systemd/user/docker.service`,
which would otherwise shadow the managed unit.

## Configuration Management

- Keep code comments minimal: only concise decision rationale that the code cannot express, such as why an alternative is not used. Put what/how explanations in commit messages.

- System files are templated in `system/[component]/files/`
- User dotfiles managed via `user/dotfiles/` using `mise dotfiles apply`
- Arch installs mise from the AUR `mise-bin` package; on Gentoo, `user/mise/` installs mise and adds `~/.local/bin` to the provisioning PATH. Dotfiles recipes invoke `mise` through PATH on both platforms
- All configurations are declarative through mitamae recipes
