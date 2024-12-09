{ pkgs, ... }: let
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "master";
      sha256 = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
    };
    extraConfig = ''
      set -g @tokyo-night-tmux_window_id_style hsquare
      set -g @tokyo-night-tmux_show_datetime 0
      set -g @tokyo-night-tmux_show_git 0
    '';
  };
in {
  enable = true;

  plugins = with pkgs.tmuxPlugins; [
    tokyo-night
    {
      plugin = yank;
      extraConfig = ''
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    }
    vim-tmux-navigator
  ];

  aggressiveResize = true;
  baseIndex = 1;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  newSession = true;
  secureSocket = true;
  shell = "/run/current-system/sw/bin/nu";
  shortcut = "a";
  terminal = "screen-256color";
  mouse = true;
  historyLimit = 50000;
  escapeTime = 0;
  prefix = "C-Space";

  extraConfig = ''
    # Increase tmux messages display duration from 750ms to 4s
    set -g display-time 4000

    # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
    set -g status-interval 5

    # Focus events enabled for terminals that support them
    set -g focus-events on

    set -as terminal-features ",xterm-256color:RGB"

    # Vim style pane selection
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    set-option -g renumber-windows on

    # Bind clearing the screen
    bind L send-keys '^L'

    run-shell ${tokyo-night}/share/tmux-plugins/tokyo-night/tokyo-night.tmux

    # Use Alt-arrow keys without prefix key to switch panes
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D

    # Shift arrow to switch windows
    bind -n S-Left  previous-window
    bind -n S-Right next-window

    # Shift Alt vim keys to switch windows
    bind -n M-H previous-window
    bind -n M-L next-window

    run-shell ${tokyo-night}/share/tmux-plugins/tokyo-night/tokyo-night.tmux

    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"
  '';
}