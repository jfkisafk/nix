{ ... }: {
  enable = true;
  onActivation.cleanup = "zap";
  onActivation.upgrade = true;
  onActivation.autoUpdate = true;
  brews = [
    "herdr"
    "opencode"
    "pueue"
  ];
  casks = [
    "antigravity-cli"
    "claude"
    "claude-code"
    "copilot-money"
    "cursor"
    "dash"
    "orbstack"
    "dynamodb-local"
    "ghostty"
    "helium-browser"
    "karabiner-elements"
    "linear"
    "lunar"
    "mongodb-compass"
    "monodraw"
    "neat"
    "notion-calendar"
    "raycast"
    "signal"
    "slack"
    "tickernotch"
    "zen"
    "zoom"
  ];
}
