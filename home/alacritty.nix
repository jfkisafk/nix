{ pkgs, ... }: {
  enable = true;

  settings = {
    window = {
      padding = {
        x = 10;
        y = 10;
      };
      decorations = "Buttonless";
      opacity = 0.9;
      blur = true;
      option_as_alt = "Both";
      dynamic_title = true;
    };

    general = {
      import = [
        "${pkgs.alacritty-theme}/tokyo_night_enhanced.toml"
      ];

      live_config_reload = true;
    };

    font = let
      blexMono = style: {
        family = "BlexMono Nerd Font";
        inherit style;
      };
    in {
      size = 12.0;
      normal = blexMono "Regular";
      bold = blexMono "Bold";
      italic = blexMono "Italic";
      bold_italic = blexMono "Bold Italic";
    };

    mouse.hide_when_typing = true;

    cursor = {
      style = {
        shape = "Beam";
        blinking = "On";
      };
    };

    terminal.shell.program = "/run/current-system/sw/bin/nu";
    env.TERM = "xterm-256color";
  };
}