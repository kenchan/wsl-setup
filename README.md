# WSL Setup (Gentoo / Arch Linux)

This repository contains my personal WSL setup for Gentoo and Arch Linux using mitamae.

## Prerequisites

- Windows 11 with WSL2 enabled
- An x86_64 Gentoo or Arch Linux distribution installed on WSL2

For Arch Linux, install the official WSL image from Windows PowerShell:

```powershell
wsl --update
wsl --install -d archlinux
```

See the [Arch Linux download page](https://archlinux.org/download/#wsl-images)
for the official installation method.

## Setup Steps

### 1. Initial System Configuration

Run steps 1–3 as root inside the selected distribution. To open a root shell,
run the following in Windows PowerShell, replacing `<DistroName>` with the name
shown by `wsl --list --verbose` (for example, `archlinux`):

```powershell
wsl -d <DistroName> -u root
```

Install the prerequisites using the command for your distribution.

#### Gentoo

```shell
emerge --sync && emerge net-misc/curl dev-vcs/git app-admin/sudo app-editors/nano
```

#### Arch Linux

```shell
pacman -Syu --needed base-devel curl git sudo nano
```

`base-devel` is required before provisioning because the Arch recipe builds paru
from the AUR.

### 2. User and Security Setup

1. Set root password for administrative tasks:
   ```shell
   passwd
   ```

2. Configure sudo access for the wheel group:
   ```shell
   EDITOR=nano visudo
   ```
   Uncomment the following line:
   ```
   %wheel ALL=(ALL) ALL
   ```

3. Create a regular user and add to the wheel group (replace `kenchan` throughout
   this guide if using a different username). If running Gentoo and Arch at the
   same time, use the explicit UID/GID example below instead:
   ```shell
   useradd -m -G wheel -s /bin/bash kenchan
   passwd kenchan
   ```

   If the user already exists, add it to the group with `usermod -aG wheel kenchan`
   instead of running `useradd`.

#### Running multiple WSL2 distributions simultaneously

WSL2 distributions share a managed VM and Linux kernel, while each distribution
runs its own systemd instance. WSL2 has a limitation in isolating systemd user
services across distributions using the same UID. When running multiple
systemd-enabled WSL2 distributions simultaneously, assign distinct UIDs to their
default users to avoid these conflicts. Sharing a kernel alone does not require
unique UIDs; this is a WSL2 limitation, not a rule for independent Linux VMs.

See [Microsoft's WSL2 architecture overview](https://learn.microsoft.com/en-us/windows/wsl/compare-versions),
[WSL's systemd documentation](https://wsl.dev/technical-documentation/systemd/),
and the [ArchWiki default-user guidance](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL#Set_default_user).

For example, if an existing distribution uses UID 1000, use UID 1001 for a new
one. Using a matching primary GID is convenient, but the systemd conflict concerns
the UID. Before creating the new user, check that the IDs are unused in the target
distribution:

```shell
getent passwd 1001
getent group 1001
```

If both commands return no entries, create the group and user as root:

```shell
groupadd -g 1001 kenchan
useradd -m -u 1001 -g kenchan -G wheel -s /bin/bash kenchan
passwd kenchan
```

Choose other unused IDs if necessary, avoiding default-user UIDs used by other
simultaneously running distributions. Do not run these creation commands if the
user or group already exists.

A conflicting UID can cause `Failed to start the systemd user session` at login
and `Device or resource busy` in the `user@<UID>.service` journal. For an existing
user, end its processes in the target distribution before changing IDs from a
root session, update file ownership as needed, and restart that distribution.
Review existing data ownership first, especially if Docker is already configured.
Check the resulting user session with:

```shell
id
systemctl --user is-system-running
```

### 3. WSL Configuration

1. Configure WSL by creating/editing `/etc/wsl.conf`:
   ```shell
   nano /etc/wsl.conf
   ```
   Merge the following settings into the existing file, preserving other settings
   and avoiding duplicate sections:
   ```ini
   [boot]
   systemd=true

   [user]
   default=kenchan
   ```

   For a new environment, leave WSL's automatic DNS configuration enabled; do not
   add `generateResolvConf=false`. The existing system recipe configures
   `systemd-resolved` with custom DNS servers, so review that recipe before
   provisioning if you want to keep WSL-managed DNS.

2. Restart WSL to apply changes:
   ```powershell
   wsl --terminate <DistroName>
   wsl -d <DistroName>
   ```

   These commands run in Windows PowerShell. Termination stops processes in the
   selected distribution, so finish any work there first.

3. Check that the restarted shell uses the regular user and that sudo works:

   ```shell
   whoami
   sudo -v
   ```

### 4. Provisioning

The preparation above is shared by both distributions, apart from the initial
package installation. mitamae selects the system recipe automatically.

Before provisioning a new Arch environment, address the known recipe gaps:

- Separate root-run pacman operations from user-run AUR builds.
- Review the Docker subordinate UID/GID ranges and the custom DNS configuration.
- Update the user dotfiles recipe from rcm to the current mise-based deployment.

After those changes are available, run the following as the regular user. The
installer clones this repository and immediately applies `system.rb` via sudo:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kenchan/wsl-setup/master/install.sh)"
```

Then authenticate with GitHub and apply the user configuration from the repository
directory, without sudo:

```shell
cd ~/src/github.com/kenchan/wsl-setup
gh auth login
bin/mitamae local user.rb
```
