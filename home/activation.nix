{ pkgs, lib, ... }: {
  generateSshKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      /run/current-system/sw/bin/ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "contact@stelo.dev"
      chmod 600 "$HOME/.ssh/id_ed25519"
      chmod 644 "$HOME/.ssh/id_ed25519.pub"
      ${pkgs.gh}/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title darkstar
      ${pkgs.gh}/bin/gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title darkstar
    fi
  '';

  sshPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "$HOME/.ssh" ]; then
      chmod 700 "$HOME/.ssh"
    fi
  '';

  postActivation = lib.hm.dag.entryAfter ["writeBoundary"] ''
    current_shell=$(basename "$SHELL")
    if [ "$current_shell" != "nu" ]; then
      echo "Changing shell to nushell..."
      /usr/bin/chsh -s /run/current-system/sw/bin/nu
    else
      echo "Shell is already nushell, no change needed."
    fi
  '';

  # After linkGeneration so mise.nix's global config exists
  installMiseTools = lib.hm.dag.entryAfter ["linkGeneration"] ''
    (
    export PATH="/run/current-system/sw/bin:/usr/bin:/bin:$PATH"
    mise upgrade
    mise prune
    )
  '';

  # herdr.nix binds ctrl+hjkl to this plugin; install needs git on PATH
  installHerdrPlugins = lib.hm.dag.entryAfter ["linkGeneration"] ''
    (
    export PATH="${pkgs.git}/bin:$PATH"
    if ! ${pkgs.herdr}/bin/herdr plugin list | grep -q vim-herdr-navigation; then
      ${pkgs.herdr}/bin/herdr plugin install paulbkim-dev/vim-herdr-navigation --yes
    fi
    )
  '';
}
