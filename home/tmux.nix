{ pkgs, ... }: {
  enable = true;

  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin;
      extraConfig = ''
        set -g @catppuccin_flavor 'mocha'
      '';
    }
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

    # Split panes
    bind V split-window -v -c "#{pane_current_path}"
    bind D split-window -h -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"
    bind X kill-window

    # Bind Alt-b and Alt-f to move between words
    bind-key -n M-Left send-keys M-b
    bind-key -n M-Right send-keys M-f
  '';
}