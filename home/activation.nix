{ pkgs, lib, ... }: let
  roseBtop = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "btop";
    rev = "main";
    sha256 = "sha256-sShQYfsyR5mq/e+pjeIsFzVZv3tCpQEdGC9bnTKlQ5c=";
  };

  roseYazi = pkgs.fetchFromGitHub {
    owner = "Msouza91";
    repo = "rose-pine.yazi";
    rev = "main";
    sha256 = "sha256-Ygx3tyefGcq3Qqk/72RSJbT5K8G7wVqIk2rCI0vKkNQ=";
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
      cp ${roseBtop}/rose-pine.theme "$themesDir/"
    fi
  '';

  # Install yazi Rose Pine theme
  yaziTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    themesDir="$HOME/.config/yazi"
    mkdir -p "$themesDir"
    if [ ! -f "$themesDir/theme.toml" ]; then
      cp ${roseYazi}/theme.toml "$themesDir/"
    fi
  '';
}
