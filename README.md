# Nixos on WSL 

https://github.com/nix-community/NixOS-WSL/


## wsl folder
Create a WSL folder where you can store tar files and create the directories for your WSL deployments.

```powershell
cd ~
mkdir wsl
cd wsl
```

## Build latest version
To build the latest version of NixOS-WSL you need a linux prompt with Nix installed with flakes enabled.
Initially use the latest release, and then build your own image based on main.

```bash
nix build github:nix-community/NixOS-WSL#nixosConfigurations.mysystem.config.system.build.installer
```

## Import image with powershell

```powershell
 wsl --import NixOS .\NixOS\ nixos-wsl-x86_64-linux.tar.gz --version 2
```

## Install temporary programs.
nix-env -i git vim

## Configure home-manager repo

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --update
```

## Clone repo

```
git clone git@github.com:dverdonschot/workstation_config.git
```

## Replace configuration

```
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix-backup
ln -s configuration.nix /etc/nixos/configuration.nix 
```

## Troubleshooting

### fchmod() of /tmp/.X11-unix failed: Read-only file system

```bash
sudo mount -o remount,rw /tmp/.X11-unix
```
