{
  config,
  pkgs,
  lib,
  ...
}:
{

  home = {
    username = "stelo";
    homeDirectory = "/Users/stelo";
    stateVersion = "26.11";
    activation = import ./activation.nix { inherit pkgs lib; };
    file = {
      ".claude/themes/rose-pine.json".text = builtins.toJSON {
        name = "Rose Pine";
        base = "dark-ansi";
        overrides = {
          claude = "#ea9a97";
          claudeShimmer = "#f6c177";
          text = "#e0def4";
          inverseText = "#191724";
          inactive = "#6e6a86";
          inactiveShimmer = "#908caa";
          subtle = "#524f67";
          suggestion = "#9ccfd8";
          permission = "#c4a7e7";
          permissionShimmer = "#e0def4";
          remember = "#c4a7e7";

          success = "#9ccfd8";
          error = "#eb6f92";
          warning = "#ea9a97";
          warningShimmer = "#e0def4";
          merged = "#c4a7e7";

          promptBorder = "#403d52";
          promptBorderShimmer = "#6e6a86";
          planMode = "#9ccfd8";
          autoAccept = "#3e8fb0";
          bashBorder = "#eb6f92";
          ide = "#3e8fb0";
          fastMode = "#f6c177";
          fastModeShimmer = "#e0def4";
          effortUltra = "#c4a7e7";

          # All diff backgrounds match base so no line or word bands are drawn.
          diffAdded = "#191724";
          diffRemoved = "#191724";
          diffAddedWord = "#191724";
          diffRemovedWord = "#191724";
          diffAddedDimmed = "#191724";
          diffRemovedDimmed = "#191724";

          userMessageBackground = "#26233a";
          userMessageBackgroundHover = "#393552";
          bashMessageBackgroundColor = "#2a273f";
          memoryBackgroundColor = "#21202e";
          selectionBg = "#403d52";

          rate_limit_fill = "#c4a7e7";
          rate_limit_empty = "#403d52";
          briefLabelYou = "#9ccfd8";
          briefLabelClaude = "#ea9a97";
        };
      };
      ".claude/claude-statusline.nu" = {
        source = ./scripts/claude-statusline.nu;
        executable = true;
      };
      # Linked whole: Claude Code rejects plugin files that resolve outside the plugin dir.
      ".claude/mods/cost-ledger".source = ./claude-mods/cost-ledger;
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
      ".config/tuicr" = {
        source = ./tuicr;
        recursive = true;
      };
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
    television = import ./television.nix { inherit pkgs; };
  };
}
