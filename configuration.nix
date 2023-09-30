{ lib, pkgs, config, modulesPath, ... }:

let 
  username_var = "ewt";
in

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
    <home-manager/nixos>
    (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
  ];


  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    #docker-desktop.enable = true;

  };
  # https://github.com/nix-community/nixos-vscode-server
  # Start service in nixos user: systemctl --user enable auto-fix-vscode-server.service --now
  services.vscode-server.enable = true;
  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    wget
    tmux
    vim
    git
    curl
    oh-my-posh
    tree
    nmap
    tree
    gtk3
    font-awesome
    powerline-fonts
    hack-font
    awscli
    git-remote-codecommit
    # python3.11
    python311
    python311Packages.virtualenv
    python311Packages.pyyaml
    nodejs
    nodePackages.npm
    nodePackages.eslint
  ];


  fonts.fontDir.enable = true; 
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["FireCode"];
    };
  };

  programs.bash = {
    interactiveShellInit = ''
      # initializing Tmux
      # [ "$EUID" -ne 0 ] && [ -z "$TMUX"  ] && { tmux attach || exec tmux new-session && exit;}
      # Loading ohh my posh config
      eval "$(oh-my-posh --init --shell bash --config /home/nixos/.config/oh-my-posh/dracula-modified-by-ewt.omp.json)"
    '';
  };

  system.stateVersion = "23.05";

  # Home-manager

  # Nixos user

  home-manager.users.nixos = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      curl
    ];
     programs.git = {
      enable = true;
      userName = "${username_var}";
      userEmail = "${username_var}@mail.com";
    };
    programs.neovim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        dracula-nvim
      ];
      extraConfig = ''
        set number relativenumber
        set paste
        syntax on
        colorscheme dracula
        set tabstop=4
        set autoindent
        set expandtab
        set softtabstop=4
        set ruler
      '';
    };
    programs.tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
          sensible
	  yank
	  {
	      plugin = dracula;
	      extraConfig = ''
	          set -g @plugin "dracula/tmux"
	      '';
	  }
      ];
      extraConfig = ''
          set -sg escape-time 50
      '';
    };
    xdg.configFile.oh-my-posh = {
      source = ./config/oh-my-posh;
      recursive = true;
    };
  };
}
