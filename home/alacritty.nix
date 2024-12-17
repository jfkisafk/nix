{ pkgs, ... }: {
  enable = true;

  settings = {
    window = {
      padding = {
        x = 5;
        y = 5;
      };
      decorations = "Buttonless";
      option_as_alt = "Both";
      dynamic_title = true;
    };

    general = {
      import = [
        "${pkgs.fetchFromGitHub {
          owner = "rose-pine";
          repo = "alacritty";
          rev = "main";
          sha256 = "sha256-LU8H4e5bzCevaabDgVmbWoiVq7iJ4C1VfQrWGpRwLq0=";
        }}/dist/rose-pine.toml"
      ];

      live_config_reload = true;
    };

    font = let
      agaveMono = style: {
        family = "Agave Nerd Font Mono";
        inherit style;
      };
    in {
      size = 15;
      normal = agaveMono "Regular";
      bold = agaveMono "Bold";
      italic = agaveMono "Italic";
      bold_italic = agaveMono "Bold Italic";
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
