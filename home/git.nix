{ pkgs, ... }: {
  enable = true;
  lfs.enable = true;

  userName = "stelo";
  userEmail = "contact@stelo.dev";

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
    ".factorypath"
    ".settings/*"
    "*.bak.ts"
    "*.bak"
    "jsconfig.json"
    "annotation-generated-src"
  ];

  extraConfig = {
    core = {
      editor = "nvim -f";
      pager = "delta";
      whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
    };

    color = {
      ui = true;
      branch = {
        current = "yellow bold";
        local = "green bold";
        remote = "cyan bold";
      };
      diff = {
        meta = "yellow";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
        commit = "yellow bold";
      };
      "diff-highlight" = {
        oldNormal = "red bold";
        oldHighlight = "red bold 52";
        newNormal = "green bold";
        newHighlight = "green bold 22";
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
    };

    filter.lfs = {
      smudge = "git-lfs smudge -- %f";
      process = "git-lfs filter-process";
      required = true;
      clean = "git-lfs clean -- %f";
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
    user.signingKey = "~/.ssh/id_ed25519.pub";
  };
}
