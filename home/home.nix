{ pkgs, lib, ... }: {

  home = {
    username = "stelo";
    homeDirectory = "/Users/stelo";
    stateVersion = "25.05";
    activation = import ./activation.nix { inherit pkgs lib; };
  };

  programs = {
    home-manager.enable = true;
    atuin = import ./atuin.nix { inherit pkgs; };
    awscli = import ./aws.nix { inherit pkgs; };
    nushell = import ./nu.nix { inherit pkgs; };
    starship = import ./starship.nix { inherit pkgs; };
    git = import ./git.nix { inherit pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    carapace = import ./carapace.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix { inherit pkgs; };
    bat = import ./bat.nix { inherit pkgs; };
    direnv = import ./direnv.nix { inherit pkgs; };
    btop = import ./btop.nix { inherit pkgs; };
    yazi = import ./yazi.nix { inherit pkgs; };
  };
}
