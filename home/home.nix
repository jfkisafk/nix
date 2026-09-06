{ pkgs, lib, ... }: {

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
      ".config/atuin/themes/rose-pine.toml".text = ''
        [theme]
        name = "rose-pine"

        [colors]
        AlertInfo = "#9ccfd8"
        AlertWarn = "#f6c177"
        AlertError = "#eb6f92"
        Annotation = "#6e6a86"
        Base = "#e0def4"
        Guidance = "#908caa"
        Important = "#eb6f92"
        Title = "#c4a7e7"
        Muted = "#6e6a86"
        SyntaxCommand = "#3e8fb0"
        SyntaxFlag = "#ea9a97"
        SyntaxString = "#9ccfd8"
        SyntaxVariable = "#c4a7e7"
        SyntaxOperator = "#e0def4"
        SyntaxComment = "#6e6a86"
      '';
      ".gemini/antigravity-cli/statusline.nu" = {
        source = ./agy-statusline.nu;
        executable = true;
      };
      ".claude/claude-statusline.nu" = {
        source = ./claude-statusline.nu;
        executable = true;
      };
    };
  };

  programs = {
    home-manager.enable = true;
    atuin = import ./atuin.nix { inherit pkgs; };
    awscli = import ./aws.nix { inherit pkgs; };
    nushell = import ./nu.nix { inherit pkgs; };
    starship = import ./starship.nix { inherit pkgs; };
    git = import ./git.nix { inherit pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    carapace = import ./carapace.nix { inherit pkgs; };
    bat = import ./bat.nix { inherit pkgs; };
    direnv = import ./direnv.nix { inherit pkgs; };
    btop = import ./btop.nix { inherit pkgs; };
    yazi = import ./yazi.nix { inherit pkgs; };
    lazygit = import ./lazygit.nix { inherit pkgs; };
    k9s = import ./k9s.nix { inherit pkgs; };
    ripgrep = import ./ripgrep.nix { inherit pkgs; };
    claude-code = import ./claude.nix { inherit pkgs; };
    opencode = import ./opencode.nix { inherit pkgs; };
    antigravity-cli = import ./antigravity.nix { inherit pkgs; };
    ghostty = import ./ghostty.nix { inherit pkgs; };
  };
}
