# Nixos on WSL 

This is my try at creating a Nixos on WSL "develop environment".

The aim is to be able to develop in style with Python, Typescript, CDK, AWS, Azure, Terraform.

The setup contains a customized prompt that is helpfull in many ways.

https://github.com/nix-community/NixOS-WSL/

## Users
Currently the setup is to use the standard nixos user with the ability to become root.

It's possible to copy the codeblock for Nixos user and create a new user, 
you will also have to create the user in the environment.

## Installed features
* tmux with dracula theme
* nvim editor with dracula theme
* vscode-server for vscode wsl support
* oh-my-posh with customized dracula theme 
* python virtualenv to build new virtual environments



## wsl folder

In Windows create a WSL folder where you can store tar files and create the directories for your WSL deployments.

```powershell
cd ~
mkdir wsl
cd wsl
```
## Download Release

Download the latest version of NixOS-WSL (nixos-wsl.tar.gz) and copy it to the wsl folder.

[Nixos WSL Releases](https://github.com/nix-community/NixOS-WSL/releases)


## Import image with powershell

```powershell
 wsl --import NixOS .\NixOS\nixos-wsl.tar.gz --version 2
```

## nixos as root
Untill I better understand Nixos and root / normal user, we do everything as root user.
Nixos can do sudo su to become root user.

```
sudo su
```

## Install temporary programs.
To clone the git repo and edit with vim install both with nix-env
```
nix-env -i git vim
```

## Configure home-manager repo

Make sure all the correct repositories are present before we run `nixos-rebuild switch`

```
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --update
nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
nix-channel --update
```

## Clone repo
Clone repository from github.

```
git clone git@github.com:dverdonschot/nixos-wsl-dev-environment.git
```

## Replace configuration
If you don't change folder root starts at /, and the repo will be cloned at /nixos-wsl-dev-environment

```
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix-backup
ln -s /nixos-wsl-dev-environment/configuration.nix /etc/nixos/configuration.nix 
```
## nixos-rebuild switch
Now rebuild nixos with the configuration.nix from our repo.

```
nixos-rebuild switch
```
After you deploy the code you need to login again for the changes to take affect.

## Windows Nerdfont to render icons correctly
Some of the elements used in oh-my-posh need nerdfonts installed on Windows,
and a Nerdfont selected in the terminal program for your wsl distribution.
After you run `nixos-rebuild switch` go to terminal settings, 
select your WSL distrubtion, go to appearance, fonts and select a nerdfont

### How to install Nerdfont on Windows
You can download Nerdfonts and then add them to your Windows fonts.
https://www.nerdfonts.com/font-downloads

## Troubleshooting

### No Internet connectivity / DNS not working
/etc/wsl.conf and /etc/resolv.conf configure DNS.
```
/etc/wsl.conf
generateResolvConf can be turned to false.
/etc/resolv.conf
nameserver 1.1.1.1
```
### fchmod() of /tmp/.X11-unix failed: Read-only file system

```bash
sudo mount -o remount,rw /tmp/.X11-unix
```

### rsync: [sender] change_dir "/nix/store/5jghxc14h21772flmd4ldpqy40rvl3xa-nixos-system-nixos-23.05.3881.5cfafa12d573/sw/share/icons" failed: No such file or directory (2)

```bash
mkdir /nix/store/5jghxc14h21772flmd4ldpqy40rvl3xa-nixos-system-nixos-23.05.3881.5cfafa12d573/sw/share/icons
```
