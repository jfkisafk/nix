{ pkgs, ... }: {
  NSGlobalDomain = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    NSScrollAnimationEnabled = true;
    NSDocumentSaveNewDocumentsToCloud = false;
    NSAutomaticInlinePredictionEnabled = true;
    NSAutomaticQuoteSubstitutionEnabled = true;
    NSAutomaticDashSubstitutionEnabled = true;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = true;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    AppleTemperatureUnit = "Celsius";
    AppleMeasurementUnits = "Centimeters";
    AppleInterfaceStyle = "Dark";
    AppleICUForce24HourTime = true;
    AppleFontSmoothing = 2;
    _HIHideMenuBar = true;
    "com.apple.keyboard.fnState" = true;
    "com.apple.mouse.tapBehavior" = 1;
    "com.apple.sound.beep.feedback" = 1;
    "com.apple.trackpad.enableSecondaryClick" = true;
    "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
  };
  finder = {
    _FXShowPosixPathInTitle = true;
    _FXSortFoldersFirst = true;
    FXEnableExtensionChangeWarning = false;
    FXPreferredViewStyle = "clmv";
    FXRemoveOldTrashItems = true;
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    ShowPathbar = true;
    ShowStatusBar = true;
    ShowRemovableMediaOnDesktop = false;
    NewWindowTarget = "Home";
    QuitMenuItem = true;
  };
  controlcenter = {
    BatteryShowPercentage = true;
    AirDrop = false;
    Bluetooth = false;
    Display = false;
    NowPlaying = false;
    Sound = false;
    FocusModes = true;
  };
  ActivityMonitor.IconType = 5;
  hitoolbox.AppleFnUsageType = "Do Nothing";
  LaunchServices.LSQuarantine = false;
  loginwindow.GuestEnabled = false;
  menuExtraClock = {
    Show24Hour = true;
    ShowDate = 0;
    ShowDayOfWeek = true;
  };
  screencapture.location = "/tmp/";
  screensaver = {
    askForPassword = true;
    askForPasswordDelay = 900;
  };
  SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  trackpad = {
    ActuationStrength = 1;
    Clicking = true;
    FirstClickThreshold = 1;
    SecondClickThreshold = 1;
    TrackpadRightClick = true;
  };
  dock = {
    autohide = true;
    magnification = false;
    minimize-to-application = true;
    mineffect = "genie";
    show-recents = false;
    show-process-indicators = true;
    launchanim = true;
    orientation = "bottom";
    tilesize = 40;
    persistent-apps = [
      "/System/Applications/Apps.app"
      "/Applications/Ghostty.app"
      "/Applications/Bear.app"
      "/Applications/Copilot.app"
      "/Applications/Cursor.app"
      "/Applications/Gifox.localized/Gifox.app"
      "/Applications/Hoppscotch.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Photos.app"
      "/System/Applications/Music.app"
      "/System/Applications/Passwords.app"
      "/Applications/Raycast.app"
      "/System/Cryptexes/App/System/Applications/Safari.app"
      "/System/Applications/System Settings.app"
      "/Applications/TradingView.app"
    ];
    persistent-others = [];
  };
}
