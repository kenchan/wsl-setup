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

## Configuration Management

- System files are templated in `system/[component]/files/`
- User dotfiles managed via `user/dotfiles/` using rcm/stow
- All configurations are declarative through mitamae recipes