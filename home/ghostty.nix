{ pkgs, ... }: {
  enable = true;
  package = null;

  settings = {
    auto-update = "download";
    auto-update-channel = "stable";

    click-repeat-interval = 500;

    command = "/run/current-system/sw/bin/nu";

    font-family = "JetbrainsMono Nerd Font";
    font-family-bold = "JetbrainsMono Nerd Font Bold";
    font-size = 12.75;
    font-feature = [
      "liga"
      "calt"
      "dlig"
    ];

    cursor-style = "underline";
    cursor-style-blink = true;

    window-padding-x = 7;
    window-padding-y = 7;
    window-padding-color = "extend";
    window-padding-balance = true;
    window-vsync = true;
    window-inherit-working-directory = true;
    window-inherit-font-size = true;
    background-opacity = 0.95;
    background-blur-radius = 100;
    minimum-contrast = 1.5;

    macos-titlebar-style = "hidden";
    macos-secure-input-indication = false;
    macos-option-as-alt = true;
    macos-icon = "xray";

    mouse-hide-while-typing = true;
    link-url = true;
    link-previews = true;
    scrollback-limit = 100000000;
    theme = "light:Rose Pine Dawn,dark:Rose Pine";

    palette = [
      "2=#3e8fb0"
      "6=#ea9a97"
      "10=#3e8fb0"
      "14=#ea9a97"
    ];
  };
}
