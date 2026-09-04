{ pkgs, lib, ... }: {
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
    (
    export PATH="/run/current-system/sw/bin:/usr/bin:/bin:$PATH"

    mise settings set python.compile false

    tools=(
    "node@lts"
    "deno@2"
    "dotnet@10"
    "bun@1"
    "yarn@4"
    "python@3"
    "poetry@1"
    "java@corretto-26"
    "rust@stable"
    "go@1"
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
    )
  '';
}
