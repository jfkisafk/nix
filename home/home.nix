{ config, pkgs, lib, ... }: {

  home.username = "stelo";
  home.homeDirectory = "/Users/stelo";
  home.stateVersion = "25.05";

  programs = {
    home-manager.enable = true;
    awscli = import ./aws.nix { inherit pkgs; };
    nushell = import ./nu.nix { inherit pkgs; };
    starship = import ./starship.nix { inherit pkgs; };
    git = import ./git.nix { inherit pkgs; };
    alacritty = import ./alacritty.nix { inherit pkgs; };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    bat = {
      enable = true;
      config = {
        map-syntax = [
          "*.jenkinsfile:Groovy"
          "*.props:Java Properties"
        ];
        theme = "base16";
      };
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      mise.enable = true;
      silent = true;
      config.whitelist = {
        prefix = [ "/Volumes" "/private/tmp" ];
      };
    };
  };

  # Generate SSH key if it doesn't exist
  home.activation.generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      /run/current-system/sw/bin/ssh-keygen -t ed25519-sk -f "$HOME/.ssh/id_ed25519" -N "" -C "contact@stelo.dev"
      chmod 600 "$HOME/.ssh/id_ed25519"
      chmod 644 "$HOME/.ssh/id_ed25519.pub"
      /run/current-system/sw/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title darkstar
      /run/current-system/sw/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title darkstar
    fi
  '';

  # Alternative approach: Add to activation script
  home.activation.sshPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "$HOME/.ssh" ]; then
      chmod 700 "$HOME/.ssh"
    fi
  '';
} 
