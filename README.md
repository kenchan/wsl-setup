# WSL Gentoo Setup

This repository contains my personal WSL setup for Gentoo distribution.

## Prerequisites

- Windows 11 with WSL2 enabled
- Gentoo WSL installed

## Setup Steps

### 1. Initial System Configuration

First, update the package database and install required packages:

```shell
emerge --sync && emerge curl dev-vcs/git sudo
```

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

3. Create a regular user and add to the wheel group:
   ```shell
   useradd -m -G wheel kenchan
   passwd kenchan
   ```

### 3. WSL Configuration

1. Configure WSL by creating/editing `/etc/wsl.conf`:
   ```shell
   nano /etc/wsl.conf
   ```
   Add the following content:
   ```ini
   [boot]
   systemd=true

   [user]
   default=kenchan

   [network]
   generateResolvConf=false
   ```

2. Restart WSL to apply changes:
   ```shell
   # Run this command from Windows PowerShell
   wsl --shutdown
   ```

### 4. Provisioning

After WSL restarts, run the following command to start the provisioning process:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kenchan/wsl-setup/master/install.sh)"
```