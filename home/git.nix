{ pkgs, ... }: {
  enable = true;
  lfs.enable = true;

  # programs.delta sets pager.diff too, and settings strips mkForce; diffnav renders through delta anyway.
  iniContent.pager.diff = pkgs.lib.mkForce "diffnav";

  ignores = [
    "*.iml"
    ".idea/"
    "build/"
    "*.bak.ts"
    "*.bak"
    "CLAUDE.local.md"
    ".claude/settings.local.json"
    "annotation-generated-src"
    "node_modules"
    ".venv"
    ".mise.local.toml"
    "mise.local.toml"
    "docker-compose.override.yml"
    "__pycache__"
    "dist/"
    "out/"
    "target/"
    ".next"
    ".nuxt"
    ".turbo"
    ".DS_Store"
    ".env"
    ".env*.local"
    "coverage/"
    ".cache"
    ".terraform"
    ".parcel-cache"
  ];

  settings = {
    core = {
      editor = "nvim -f";
      whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
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

    gpg.format = "ssh";
    rebase.autoStash = true;
    rerere.enabled = true;
    merge.conflictStyle = "zdiff3";
    pull.rebase = true;
    "diff \"pkgconfig\"".xfuncname = "[-[:alpha:]]+.*=.*\\{";
    init.defaultBranch = "main";
    commit.gpgsign = true;
    tag.gpgsign = true;
    gui.skipDiscardChangeWarning = true;
  };
}
