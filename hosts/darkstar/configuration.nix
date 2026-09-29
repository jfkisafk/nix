{
  pkgs,
  lib,
  ...
}:
{

  # Set the home directory for the user.
  users.users.stelo.home = "/Users/stelo";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable sudo authentication via Touch ID.
  security.pam.services.sudo_local.touchIdAuth = true;

  # Run tailscaled as a persistent launchd daemon.
  services.tailscale.enable = true;
  environment.etc."resolver/ts.net".enable = lib.mkForce false;

  # darwin-rebuild's default flake; nvim's nixd config reads it too.
  # A string, not ./. — a path literal would copy the flake into the store instead of linking the checkout.
  environment.etc."nix-darwin".source = "/Volumes/nitro/nix";

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    primaryUser = "stelo";
    startup.chime = false;
    defaults = import ../../system/mac.nix { };
  };

  # Packages
  homebrew = import ../../pkgs/brew.nix { };
  fonts = import ../../pkgs/fonts.nix { inherit pkgs; };

  # Environment
  environment = {
    shells = with pkgs; [
      fish
      nushell
      zsh
    ];
    systemPackages = import ../../pkgs/system.nix { inherit pkgs; };
  };
}
