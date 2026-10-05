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
      # home-manager's mise init is generated in the Nix sandbox and overwrites PATH without these
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
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

    cr = "tuicr";
    crw = "tuicr -w";

    neo = "nerdfetch";
    speed = "networkQuality -p";
  };

  environmentVariables = {
    CARAPACE_BRIDGES = "zsh,fish,bash";
    CARAPACE_MATCH = 1;
    LESSOPEN = "|batpipe %s";
    LESS = "-R";
    BATPIPE = "color";
  };
}
