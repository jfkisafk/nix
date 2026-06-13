{ ... }: {
  enable = true;
  onActivation.cleanup = "zap";
  onActivation.upgrade = true;
  onActivation.autoUpdate = true;
  brews = [
    "pueue"
  ];
  casks = [
    "chatgpt"
    "claude"
    "copilot-money"
    "cursor"
    "dash"
    "docker-desktop"
    "dynamodb-local"
    "ghostty"
    "hoppscotch"
    "karabiner-elements"
    "linear"
    "lunar"
    "microsoft-teams"
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
