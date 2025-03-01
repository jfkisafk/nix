{ pkgs, ... }: {
  enable = true;
  settings = {
    k9s = {
      liveViewAutoRefresh = true;
      screenDumpDir = "/Users/stelo/Library/Application Support/k9s/screen-dumps";
      refreshRate = 2;
      maxConnRetry = 5;
      readOnly = false;
      noExitOnCtrlC = false;
      ui = {
        enableMouse = true;
        headless = false;
        logoless = true;
        crumbsless = false;
        reactive = true;
        noIcons = false;
        defaultsToFullScreen = false;
        skin = "rose-pine";
      };
      skipLatestRevCheck = false;
      disablePodCounting = false;
      shellPod = {
        image = "busybox:1.35.0";
        namespace = "default";
        limits = {
          cpu = "100m";
          memory = "100Mi";
        };
      };
      imageScans = {
        enable = false;
        exclusions = {
          namespaces = [];
          labels = {};
        };
      };
      logger = {
        tail = 100;
        buffer = 5000;
        sinceSeconds = -1;
        textWrap = false;
        showTime = true;
      };
      thresholds = {
        cpu = {
          critical = 90;
          warn = 70;
        };
        memory = {
          critical = 90;
          warn = 70;
        };
      };
    };
  };
}
