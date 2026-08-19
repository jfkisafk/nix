{ ... }: {
  enable = true;
  onActivation.cleanup = "zap";
  onActivation.upgrade = true;
  onActivation.autoUpdate = true;
  brews = [
    "herdr"
    "pueue"
  ];
  casks = [
    "antigravity-cli"
    "claude"
    "copilot-money"
    "cursor"
    "dash"
    "docker-desktop"
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
