# My personal WSL setup

## Supported Distributions

- Gentoo

## Usage

First, install required software.

```
emerge --sync && emerge curl dev-vcs/git sudo
```

Allow wheel group to use `sudo`.

```
visudo
```

Set root password.

```
passwd
```

Create a regular user and add it to the wheel group.

```
useradd -G wheel kenchan
```

Set password for the regular user.

```
passwd kenchan
```

Configure `/etc/wsl.conf` as follows and restart.

```
[boot]
systemd=true

[user]
default=kenchan

[network]
generateResolvConf=false
```

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kenchan/wsl-setup/master/install.sh)"
```
