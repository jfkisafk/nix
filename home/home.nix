{ config, pkgs, lib, ... }: {

  home = {
    username = "stelo";
    homeDirectory = "/Users/stelo";
    stateVersion = "25.05";
    activation = import ./activation.nix { inherit pkgs lib; };
    file = {
      ".claude/themes/rose-pine.json".text = builtins.toJSON {
        name = "Rose Pine";
        base = "dark-ansi";
        overrides = {
          claude = "#c4a7e7";
          error = "#eb6f92";
          success = "#9ccfd8";
          warning = "#f6c177";
          diffAdded = "#3e8fb0";
          diffRemoved = "#eb6f92";
          promptBorder = "#31748f";
          planMode = "#ea9a97";
          text = "#e0def4";
          inactive = "#6e6a86";
          userMessageBackground = "#393552";
          claudeShimmer = "#907aa9";
          inactiveShimmer = "#908caa";
          permissionShimmer = "#b4637a";
          warningShimmer = "#ea9d34";
          promptBorderShimmer = "#3e8fb0";
          fastModeShimmer = "#d7827e";
          autoAcceptShimmer = "#56949f";
        };
      };
      ".claude/claude-statusline.nu" = {
        source = ./scripts/claude-statusline.nu;
        executable = true;
      };
      ".config/karabiner/karabiner.json".source = import ./karabiner.nix { inherit pkgs; };
      # opencode is yargs-based and ships no zsh/fish/bash completion file for CARAPACE_BRIDGES to find
      "Library/Application Support/carapace/specs/opencode.yaml".text = ''
        name: opencode
        parsing: disabled
        completion:
          positionalany: ["$carapace.bridge.Yargs([opencode])"]
      '';
      ".config/diffnav/config.yml".text = ''
        ui:
          hideHeader: true
          sideBySide: false
          icons: nerd-fonts-full
      '';
      # Out-of-store so nvim config edits apply without a rebuild.
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/Volumes/nitro/nvim";
    };
  };

  programs = {
    home-manager.enable = true;
    atuin = import ./atuin.nix { };
    awscli = import ./aws.nix { };
    nushell = import ./nu.nix { };
    starship = import ./starship.nix { };
    git = import ./git.nix { inherit pkgs; };
    delta = import ./delta.nix { };
    gh = import ./gh.nix { inherit pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    carapace = import ./carapace.nix { };
    bat = import ./bat.nix { inherit pkgs; };
    direnv = import ./direnv.nix { };
    btop = import ./btop.nix { };
    superfile = import ./superfile.nix { };
    lazygit = import ./lazygit.nix { };
    k9s = import ./k9s.nix { };
    ripgrep = import ./ripgrep.nix { };
    claude-code = import ./claude.nix { };
    opencode = import ./opencode.nix { };
    ghostty = import ./ghostty.nix { };
    mise = import ./mise.nix { };
    zoxide = import ./zoxide.nix { };
    herdr = import ./herdr.nix { };
  };
}
