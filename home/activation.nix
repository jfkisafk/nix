{ pkgs, lib, ... }: let
  rosePineTheme = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "btop";
    rev = "main";
    sha256 = "sha256-sShQYfsyR5mq/e+pjeIsFzVZv3tCpQEdGC9bnTKlQ5c=";
  };
in {
  ## Generate SSH key if it doesn't exist
  generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      /run/current-system/sw/bin/ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "contact@stelo.dev"
      chmod 600 "$HOME/.ssh/id_ed25519"
      chmod 644 "$HOME/.ssh/id_ed25519.pub"
      /run/current-system/sw/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title darkstar
      /run/current-system/sw/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title darkstar
    fi
  '';

  # Alternative approach: Add to activation script
  sshPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "$HOME/.ssh" ]; then
      chmod 700 "$HOME/.ssh"
    fi
  '';

  # Install btop Rose Pine theme
  btopTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    themesDir="$HOME/.config/btop/themes"
    mkdir -p "$themesDir"
    if [ ! -f "$themesDir/rose-pine.theme" ]; then
      cp ${rosePineTheme}/rose-pine.theme "$themesDir/"
    fi
  '';
}