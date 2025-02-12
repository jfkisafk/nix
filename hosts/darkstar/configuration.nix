{ pkgs, config, inputs, ... }: {

  # Set the home directory for the user.
  users.users.stelo.home = "/Users/stelo";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable sudo authentication via Touch ID.
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    startup.chime = false;
    defaults = import ../../system/mac.nix { inherit pkgs; };
  };

  # Packages
  homebrew = import ../../pkgs/brew.nix { inherit pkgs; };
  fonts = import ../../pkgs/fonts.nix { inherit pkgs; };

  # Environment
  environment = {
    shells = with pkgs; [
      fish
      nushell
      zsh
    ];
    systemPackages = import ../../pkgs/system.nix { inherit pkgs inputs; };
  };
}
