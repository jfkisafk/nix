{ pkgs, ... }: {
  enable = true;

  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = yank;
      extraConfig = ''
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    }
    {
      plugin = vim-tmux-navigator;
      extraConfig = ''
        set -g @vim_navigator_mapping_left "C-Left C-h"
        set -g @vim_navigator_mapping_right "C-Right C-l"
        set -g @vim_navigator_mapping_up "C-Up C-k"
        set -g @vim_navigator_mapping_down "C-Down C-j"
        set -g @vim_navigator_mapping_prev ""
      '';
    }
    resurrect
    {
      plugin = continuum;
      extraConfig = ''
        set -g @resurrect-capture-pane-contents 'on'
        set -g @continuum-restore 'on'
      '';
    }
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

    # Shift arrow to switch windows
    bind -n S-Left  previous-window
    bind -n S-Right next-window

    # Split panes
    unbind %
    bind | split-window -h -c "#{pane_current_path}"

    unbind '"'
    bind _ split-window -v -c "#{pane_current_path}"

    unbind r
    bind r source-file ~/.config/tmux/tmux.conf

    unbind z
    bind -r m resize-pane -Z

    unbind &
    bind X kill-window

    # Bind Alt-b and Alt-f to move between words
    bind-key -n M-Left send-keys M-b
    bind-key -n M-Right send-keys M-f

    # Rose Pine theme

    thm_base="#191724";
    thm_surface="#1f1d2e";
    thm_overlay="#26233a";
    thm_muted="#6e6a86";
    thm_subtle="#908caa";
    thm_text="#e0def4";
    thm_love="#eb6f92";
    thm_gold="#f6c177";
    thm_rose="#ebbcba";
    thm_pine="#31748f";
    thm_foam="#9ccfd8";
    thm_iris="#c4a7e7";
    thm_hl_low="#21202e";
    thm_hl_med="#403d52";
    thm_hl_high="#524f67";

    # Theoretically messages (need to figure out color placement)
    set-option -gq message-style "fg=$thm_muted,bg=$thm_base"
    set-option -gq message-command-style "fg=$thm_base,bg=$thm_gold"

    # Pane styling
    set-option -gq pane-border-style "fg=$thm_hl_high"
    set-option -gq pane-active-border-style "fg=$thm_gold"
    set-option -gq display-panes-active-colour "$thm_text"
    set-option -gq display-panes-colour "$thm_gold"

    # Windows
    set-window-option -gq window-status-style "fg=$thm_iris,bg=default"
    set-window-option -gq window-status-activity-style "fg=$thm_gold,bg=default"
    set-window-option -gq window-status-current-style "fg=$thm_foam,bg=default"

    # Window appearence switcher
    set-window-option -gq window-status-separator "   "
    set-window-option -gq window-status-format "#[fg=$thm_iris]#I#[fg=$thm_iris]  #[fg=$thm_iris]#W"
    set-window-option -gq window-status-current-format "#I#[fg=$thm_foam]  #[fg=$thm_foam]#W"
    set-window-option -gq clock-mode-colour "$thm_love"
    set-window-option -gq mode-style "fg=$thm_gold"

    # Status bar
    set-option -gq status on
    set-option -gq status-style "fg=$thm_pine,bg=default"
    set-option -gq monitor-activity on
    set-option -gq status-left-length 200
    set-option -gq status-right-length 200
    set-option -gq status-left " #[fg=#{?client_prefix,#$thm_love,#$thm_text}] #[fg=$thm_text]#S  #[fg=$thm_subtle] #[fg=$thm_rose]#W "
    set-option -gq status-right " #[fg=$thm_subtle]  #[fg=$thm_rose]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-3 | rev) "
    set -Fg "status-format[1]" "#{status-format[0]}"
    set -g "status-format[0]" ""
    set -g status 2
  '';
}
