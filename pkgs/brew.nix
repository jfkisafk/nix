{ ... }: {
  enable = true;
  onActivation.cleanup = "zap";
  onActivation.upgrade = true;
  onActivation.autoUpdate = true;
  brews = [
    "opencode"
    "pueue"
  ];
  casks = [
    "claude-code@latest"
    "copilot-money"
    "cursor"
    "orbstack"
    "ghostty"
    "helium-browser"
    "karabiner-elements"
    "linear"
    "lunar"
    "monodraw"
    "neat"
    "raycast"
    "signal"
    "tickernotch"
    "zoom"
  ];
}
