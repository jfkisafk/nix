{ ... }: {
  enable = true;

  settings = {
    onboarding = false;

    theme = {
      name = "rose-pine";
      custom = {
        accent = "#ea9a97";
        green = "#3e8fb0";
        blue = "#3e8fb0";
      };
    };

    keys = {
      prefix = "ctrl+a";

      split_vertical = "prefix+|";
      split_horizontal = "prefix+_";
      close_pane = "prefix+x";

      zoom = "prefix+z";

      new_workspace = "prefix+c";
      close_workspace = "prefix+shift+x";
      rename_workspace = "prefix+,";
      previous_workspace = "ctrl+shift+k";
      next_workspace = "ctrl+shift+j";

      new_worktree = "prefix+shift+c";
      remove_worktree = "prefix+shift+d";
      open_worktree = "prefix+shift+o";

      command = [
        {
          key = "ctrl+h";
          type = "plugin_action";
          command = "vim-herdr-navigation.left";
          description = "navigate left (vim/herdr)";
        }
        {
          key = "ctrl+j";
          type = "plugin_action";
          command = "vim-herdr-navigation.down";
          description = "navigate down (vim/herdr)";
        }
        {
          key = "ctrl+k";
          type = "plugin_action";
          command = "vim-herdr-navigation.up";
          description = "navigate up (vim/herdr)";
        }
        {
          key = "ctrl+l";
          type = "plugin_action";
          command = "vim-herdr-navigation.right";
          description = "navigate right (vim/herdr)";
        }
      ];
    };

    ui = {
      sidebar_collapsed_mode = "hidden";
      confirm_close = false;
      hide_tab_bar_when_single_tab = true;
      prompt_new_workspace_name = true;
      agent_panel_sort = "priority";
      sound = {
        done_path = "${./herdr/glass.mp3}";
        request_path = "${./herdr/submarine.mp3}";
      };

      toast.delivery = "herdr";
    };

    advanced.scrollback_limit_bytes = 100000000;
  };
}
