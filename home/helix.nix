{ pkgs, ... }: {
  enable = true;
  settings = {
    theme = "rose_pine";
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
  };
}
