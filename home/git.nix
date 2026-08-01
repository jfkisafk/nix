{ pkgs, ... }: {
  enable = true;
  lfs.enable = true;

  ignores = [
    "*.iml"
    ".idea/*"
    "build"
    "*output.dir/*"
    ".noseids"
    ".rakeTasks"
    "*apollo-shim/*"
    "definition.yaml"
    "*\${output.dir}/*"
    ".classpath"
    ".project"
    "*.d.ts"
    ".factorypath"
    ".settings/*"
    "*.bak.ts"
    "*.bak"
    "CLAUDE.md"
    "GEMINI.md"
    ".claude/*"
    ".gemini/*"
    "jsconfig.json"
    "annotation-generated-src"
    "node_modules"
    ".venv"
    ".editorconfig"
    ".mise.toml"
    "vendor"
    "__pycache__"
    "dist"
    "out"
    "target"
    ".next"
    ".nuxt"
    ".turbo"
    ".DS_Store"
    "Thumbs.db"
    ".env"
    ".env.local"
    ".env*.local"
    "coverage"
    ".cache"
    ".terraform"
    ".parcel-cache"
  ];

  settings = {
    core = {
      editor = "nvim -f";
      pager = "delta";
      whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      excludesfile = "~/.config/git/ignore";
    };

    user = {
      signingKey = "~/.ssh/id_ed25519.pub";
      name = "stelo";
      email = "contact@stelo.dev";
    };

    color = {
      ui = true;
      branch = {
        current = "yellow bold";
        local = "green bold";
        remote = "cyan bold";
      };
      status = {
        added = "green bold";
        changed = "yellow bold";
        untracked = "red bold";
      };
    };

    push = {
      default = "simple";
      followTags = true;
      autoSetupRemote = true;
    };

    alias = {
      dag = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
      lgb = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches";
    };

    delta = {
      side-by-side = true;
      line-numbers = true;
      hyperlinks = true;
      hyperlinks-file-link-format = "idea://open?file={path}&line={line}";
      line-numbers-minus-style = "#eb6f92";
      line-numbers-plus-style = "#9ccfd8";
      line-numbers-zero-style = "#6e6a86";
      file-style = "bold \"#9ccfd8\"";
    };

    gpg.format = "ssh";
    rebase.autoStash = true;
    rerere.enabled = true;
    interactive.diffFilter = "delta --color-only";
    merge.conflictStyle = "zdiff3";
    pull.rebase = true;
    "diff \"pkgconfig\"".xfuncname = "[-[:alpha:]]+.*=.*\\{";
    init.defaultBranch = "main";
    commit.gpgsign = true;
    tag.gpgsign = true;
    gui.skipDiscardChangeWarning = true;
  };
}
