{ ... }:

{
  enable = true;

  extraConfig = ''
    source ${./scripts/nu-base.nu}

    $env.PATH = ($env.PATH | prepend [
      "/run/current-system/sw/bin"
      $"($env.HOME)/.nix-profile/bin"
      $"($env.HOME)/.dotnet/tools"
      "/nix/var/nix/profiles/default/bin"
      "/opt/homebrew/bin"
      $"($env.HOME)/.local/share/nvim/mason/bin"
    ] | uniq)

    $env.DOTNET_ROOT = $"($env.HOME)/.local/share/mise/installs/dotnet/10"
  '';

  shellAliases = {
    vim = "nvim";
    vi = "nvim";
    vd = "nvim -d";
    cat = "bat";
    grep = "batgrep";
    rg = "batgrep";
    man = "batman";
    spf = "superfile";
    # Git aliases
    g = "tig --all";
    ga = "git add";
    gaa = "git add .";
    gd = "git diff";
    gcr = "git reset HEAD~1";
    gs = "tig status";
    com = "git commit";
    gps = "git push";
    gpl = "git pull --rebase";
    gl = "tig log --show-signature";
    gb = "git branch -vv";
    gm = "git merge";
    gc = "git checkout";
    gnb = "git checkout -b";
    gbr = "git branch -D";
    gcl = "git checkout . and git clean -d -f -x";

    neo = "nerdfetch";
    speed = "networkQuality -p";
  };

  environmentVariables = {
    CARAPACE_BRIDGES = "zsh,fish,bash";
    CARAPACE_MATCH = 1;
    LESSOPEN = "|batpipe %s";
    LESS = "-R";
    BATPIPE = "color";
    SKIM_DEFAULT_OPTIONS = "-i --ansi --delimiter ':' --cmd-prompt ' ' --preview 'bat --style=numbers,header,grid,changes --color=always --highlight-line {2} {1}' --preview-window +{2}-/2 -c \"rg {} --line-number --colors 'path:style:intense' --colors 'match:style:intense' --colors 'line:style:intense' --smart-case --hidden --color=always --glob '!.git'\"";
  };
}
