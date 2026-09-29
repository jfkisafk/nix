{ pkgs, ... }: {
  enable = true;
  firstUseCheck = false;
  # programs.zoxide already installs it.
  zoxidePackage = null;

  settings = {
    theme = "rose-pine-local";
    editor = "nvim";
    auto_check_update = false;
    # Unset fields fall back to superfile's defaults; this only silences the warning.
    ignore_missing_fields = true;
    # Read by the `y` wrapper in nu.nix.
    cd_on_quit = true;
    default_open_file_preview = true;
    show_image_preview = true;
    default_sort_type = 2;
    sort_order_reversed = true;
    code_previewer = "bat";
    nerdfont = true;
    transparent_background = false;
    sidebar_width = 20;
    metadata = true;
    enable_md5_checksum = false;
    zoxide_support = true;
  };

  # Upstream vimHotkeys.toml plus h/l navigation and the spf prompt.
  # superfile warns on any missing key, so the full set is listed.
  hotkeys = {
    confirm = [ "enter" "l" ];
    quit = [ "ctrl+c" "" ];
    list_up = [ "k" "" ];
    list_down = [ "j" "" ];
    page_up = [ "pgup" "" ];
    page_down = [ "pgdown" "" ];
    create_new_file_panel = [ "n" "" ];
    close_file_panel = [ "q" "" ];
    next_file_panel = [ "tab" "" ];
    previous_file_panel = [ "shift+tab" "" ];
    toggle_file_preview_panel = [ "f" "" ];
    open_sort_options_menu = [ "o" "" ];
    toggle_reverse_sort = [ "R" "" ];
    focus_on_process_bar = [ "ctrl+p" "" ];
    focus_on_sidebar = [ "ctrl+s" "" ];
    focus_on_metadata = [ "ctrl+d" "" ];
    file_panel_item_create = [ "a" "" ];
    file_panel_item_rename = [ "r" "" ];
    copy_items = [ "y" "" ];
    cut_items = [ "x" "" ];
    paste_items = [ "p" "" ];
    delete_items = [ "d" "" ];
    extract_file = [ "ctrl+e" "" ];
    compress_file = [ "ctrl+a" "" ];
    open_file_with_editor = [ "e" "" ];
    open_current_directory_with_editor = [ "E" "" ];
    pinned_directory = [ "P" "" ];
    toggle_dot_file = [ "." "" ];
    change_panel_mode = [ "m" "" ];
    open_help_menu = [ "?" "" ];
    open_command_line = [ ":" "" ];
    open_spf_prompt = [ ">" "" ];
    copy_path = [ "Y" "" ];
    copy_present_working_directory = [ "c" "" ];
    toggle_footer = [ "ctrl+f" "" ];
    confirm_typing = [ "enter" "" ];
    cancel_typing = [ "esc" "" ];
    parent_directory = [ "-" "h" ];
    search_bar = [ "/" "" ];
    file_panel_select_mode_items_select_down = [ "J" "" ];
    file_panel_select_mode_items_select_up = [ "K" "" ];
    file_panel_select_all_items = [ "A" "" ];
  };

  # Built-in rose-pine is mostly white and uses off-palette colors (#31784f
  # pine, greys, #ff6969, #8ec07c); this recolors it with the home/ palette.
  themes.rose-pine-local = {
    code_syntax_highlight = "rose-pine";

    file_panel_border = "#403d52";
    sidebar_border = "#191724";
    footer_border = "#403d52";

    file_panel_border_active = "#3e8fb0";
    sidebar_border_active = "#c4a7e7";
    footer_border_active = "#f6c177";
    modal_border_active = "#ea9a97";

    full_screen_bg = "#191724";
    file_panel_bg = "#191724";
    sidebar_bg = "#191724";
    footer_bg = "#191724";
    modal_bg = "#191724";

    full_screen_fg = "#e0def4";
    file_panel_fg = "#e0def4";
    sidebar_fg = "#908caa";
    footer_fg = "#908caa";
    modal_fg = "#e0def4";

    cursor = "#ea9a97";
    correct = "#9ccfd8";
    error = "#eb6f92";
    hint = "#3e8fb0";
    cancel = "#6e6a86";
    gradient_color = [ "#3e8fb0" "#eb6f92" ];

    file_panel_top_directory_icon = "#3e8fb0";
    file_panel_top_path = "#ea9a97";
    file_panel_item_selected_fg = "#f6c177";
    file_panel_item_selected_bg = "#26233a";

    sidebar_title = "#c4a7e7";
    sidebar_item_selected_fg = "#ea9a97";
    sidebar_item_selected_bg = "#26233a";
    sidebar_divider = "#908caa";

    modal_cancel_fg = "#e0def4";
    modal_cancel_bg = "#524f67";
    modal_confirm_fg = "#e0def4";
    modal_confirm_bg = "#eb6f92";

    help_menu_hotkey = "#f6c177";
    help_menu_title = "#c4a7e7";
  };

  pinnedFolders = [
    { name = "nix"; location = "/Volumes/nitro/nix"; }
    { name = "nvim"; location = "/Volumes/nitro/nvim"; }
    { name = "Downloads"; location = "/Users/stelo/Downloads"; }
  ];
}