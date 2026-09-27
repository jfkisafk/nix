{ pkgs, ... }: {
  enable = true;
  enableGitIntegration = true;

  # Diff backgrounds are love/foam blended over base at 20% (line) and 35% (emph).
  options = {
    dark = true;
    syntax-theme = "rose-pine";
    line-numbers = true;
    hyperlinks = true;

    minus-style = "syntax \"#43293a\"";
    minus-emph-style = "syntax \"#62364a\"";
    plus-style = "syntax \"#333c48\"";
    plus-emph-style = "syntax \"#475763\"";

    line-numbers-minus-style = "#eb6f92";
    line-numbers-plus-style = "#9ccfd8";
    line-numbers-zero-style = "#6e6a86";
    line-numbers-left-style = "#524f67";
    line-numbers-right-style = "#524f67";

    file-style = "bold \"#c4a7e7\"";
    file-decoration-style = "\"#c4a7e7\" ul";
    hunk-header-style = "file line-number syntax";
    hunk-header-file-style = "\"#ea9a97\"";
    hunk-header-line-number-style = "\"#f6c177\"";
    hunk-header-decoration-style = "\"#3e8fb0\" box";
    commit-style = "raw";
    commit-decoration-style = "bold \"#f6c177\" box ul";
    blame-palette = "#191724 #1f1d2e #26233a";
  };
}
