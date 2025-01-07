{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = true;

  settings = {
    log = {
      enabled = false;
    };
    manager = {
      show_hidden = true;
      sort_by = "mtime";
      sort_dir_first = true;
      sort_reverse = true;
      title_format = "";
    };
  };
}
