{ ... }: {
  enable = true;
  onActivation.cleanup = "zap";
  onActivation.upgrade = true;
  onActivation.autoUpdate = true;
  brews = [
    "pueue"
  ];
  casks = [
    "alacritty"
    "copilot"
    "cursor"
    "dash"
    "docker"
    "dynamodb-local"
    "hoppscotch"
    "intellij-idea"
    "karabiner-elements"
    "lens"
    "linear-linear"
    "logitech-options"
    "lunar"
    "microsoft-teams"
    "monodraw"
    "neat"
    "notion-calendar"
    "raycast"
    "signal"
    "slack"
    "sony-ps-remote-play"
    "tradingview"
    "zoom"
  ];
  masApps = {
    "adblock" = 1402042596;
    "craft" = 1487937127;
    "dashlane" = 517914548;
    "bear" = 1091189122;
    "bears-cntdwn" = 1536711520;
    "bears-grat" = 6443609622;
    "flighty" = 1358823008;
    "gifox" = 1461845568;
    "leaf" = 576338668;
    "ray" = 6738274497;
    "tampermonkey" = 1482490089;
    "tz-converter" = 1255311569;
    "wallpaper" = 1552826194;
  };
}