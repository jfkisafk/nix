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

  k9Repo = pkgs.fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "master";
    sha256 = "sha256-Iy2S14pEm2jHgu8Pzscgf0JFaIRmYN55ze6kAd3n1l4=";
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

  # Adds all k9s skins
  k9Skins = lib.hm.dag.entryAfter ["writeBoundary"] ''
    skinsDir="$HOME/Library/Application Support/k9s/skins"
    mkdir -p "$skinsDir"
    if [ ! -f "$skinsDir/rose-pine.yaml" ]; then
      cp ${k9Repo}/skins/*.yaml "$skinsDir/" && \
      sed -i 's/\(background: &background\) ".*"/\1 default/' "$skinsDir/rose-pine.yaml"
    fi
  '';

  # Set up default shell
  postActivation = lib.hm.dag.entryAfter ["writeBoundary"] ''
    current_shell=$(basename "$SHELL")
    if [ "$current_shell" != "nu" ]; then
      echo "Changing shell to nushell..."
      /usr/bin/chsh -s /run/current-system/sw/bin/nu
    else
      echo "Shell is already nushell, no change needed."
    fi
  '';

  # Set up mise tools
  installMiseTools = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /run/current-system/sw/bin/mise settings set python.compile false

    tools=(
    "node@lts"
    "deno@2"
    "dotnet@9"
    "bun@1"
    "python@3"
    "java@corretto-23"
    "rust@stable"
    "go@1"
    "poetry@1"
    "spectral@6"
    "terraform@1"
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
}
