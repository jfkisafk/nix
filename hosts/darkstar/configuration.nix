{ pkgs, config, ... }: {
  imports = [
    ../../darwin/pkgs.nix
    ../../darwin/sys.nix
  ];

  # Set the home directory for the user.
  users.users.stelo = {
    home = "/Users/stelo";
  };

  # Automatically update nix-daemon and packages
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable sudo authentication via Touch ID.
  security.pam.enableSudoTouchIdAuth = true;

  environment.shells = with pkgs; [
    fish
    nushell
    zsh
  ];

  # Set up mise tools and default shell
  system.activationScripts = {
    postActivation.text = ''
      chsh -s /run/current-system/sw/bin/nu
    '';
    
    installMiseTools.text = ''
      # Set up mise tools
      tools=(
        "node@lts"
        "deno@2"
        "python@3"
        "java@corretto-23"
        "rust@stable"
        "kafka@apache"
        "go@1"
        "terraform@1"
        "poetry@1"
        "kubectl@1"
      )

      for tool in "''${tools[@]}"; do
        if ! /run/current-system/sw/bin/mise current | grep -q "$(echo $tool | cut -d@ -f1)" || \
           /run/current-system/sw/bin/mise outdated --quiet | grep -q "$(echo $tool | cut -d@ -f1)"; then
          /run/current-system/sw/bin/mise use --global "$tool"
        fi
      done

      /run/current-system/sw/bin/mise upgrade
      /run/current-system/sw/bin/mise prune
    '';
  };
} 
