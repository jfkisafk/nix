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
    "claude"
    "copilot-money"
    "cursor"
    "dash"
    "docker-desktop"
    "dynamodb-local"
    "ghostty"
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
    "zen"
    "zoom"
  ];
}
