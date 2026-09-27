{ pkgs, ... }: {
  enable = true;
  extensions = [ pkgs.gh-s ];

  settings = {
    git_protocol = "ssh";
    editor = "nvim";
  };
}
