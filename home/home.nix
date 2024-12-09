{ config, pkgs, lib, ... }: {

  home = {
    username = "stelo";
    homeDirectory = "/Users/stelo";
    stateVersion = "25.05";
    activation = import ./activation.nix { inherit pkgs lib; };
  };

  programs = {
    home-manager.enable = true;
    awscli = import ./aws.nix { inherit pkgs; };
    nushell = import ./nu.nix { inherit pkgs; };
    starship = import ./starship.nix { inherit pkgs; };
    git = import ./git.nix { inherit pkgs; };
    alacritty = import ./alacritty.nix { inherit pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    carapace = import ./carapace.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix { inherit pkgs; };
    bat = import ./bat.nix { inherit pkgs; };
    direnv = import ./direnv.nix { inherit pkgs; };
  };
} 
