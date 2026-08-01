{ pkgs, ... }: {
  enable = true;
  skins = {
    "rose-pine" = {
      k9s = {
        body    = { fgColor = "#e0def4"; bgColor = "#191724"; logoColor = "#c4a7e7"; };
        prompt  = { fgColor = "#e0def4"; bgColor = "#191724"; suggestColor = "#c4a7e7"; };
        info    = { fgColor = "#c4a7e7"; sectionColor = "#e0def4"; };
        dialog  = {
          fgColor = "#e0def4"; bgColor = "#191724";
          buttonFgColor = "#e0def4"; buttonBgColor = "#c4a7e7";
          buttonFocusFgColor = "#f6c177"; buttonFocusBgColor = "#c4a7e7";
          labelFgColor = "#f6c177"; fieldFgColor = "#e0def4";
        };
        frame = {
          border  = { fgColor = "#26233a"; focusColor = "#26233a"; };
          menu    = { fgColor = "#e0def4"; keyColor = "#c4a7e7"; numKeyColor = "#c4a7e7"; };
          crumbs  = { fgColor = "#e0def4"; bgColor = "#26233a"; activeColor = "#26233a"; };
          status  = {
            newColor = "#ea9a97"; modifyColor = "#c4a7e7"; addColor = "#3e8fb0";
            errorColor = "#eb6f92"; highlightColor = "#f6c177";
            killColor = "#6272a4"; completedColor = "#6272a4";
          };
          title   = { fgColor = "#e0def4"; bgColor = "#26233a"; highlightColor = "#f6c177"; counterColor = "#c4a7e7"; filterColor = "#c4a7e7"; };
        };
        views = {
          charts = {
            bgColor = "default";
            defaultDialColors  = [ "#c4a7e7" "#eb6f92" ];
            defaultChartColors = [ "#c4a7e7" "#eb6f92" ];
          };
          table = {
            fgColor = "#e0def4"; bgColor = "#191724";
            header = { fgColor = "#e0def4"; bgColor = "#191724"; sorterColor = "#ea9a97"; };
          };
          xray = { fgColor = "#e0def4"; bgColor = "#191724"; cursorColor = "#26233a"; graphicColor = "#c4a7e7"; showIcons = false; };
          yaml = { keyColor = "#c4a7e7"; colonColor = "#c4a7e7"; valueColor = "#e0def4"; };
          logs = {
            fgColor = "#e0def4"; bgColor = "#191724";
            indicator = { fgColor = "#e0def4"; bgColor = "#c4a7e7"; toggleOnColor = "#3e8fb0"; toggleOffColor = "#26233a"; };
          };
        };
      };
    };
  };
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
