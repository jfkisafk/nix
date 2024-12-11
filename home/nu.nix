{ pkgs, ... }: {
  enable = true;

  extraConfig = ''
    let carapace_completer = {|spans|
      carapace $spans.0 nushell ...$spans | from json
    }

    let fish_completer = {|spans|
      fish --command $'complete "--do-complete=($spans | str join " ")"'
        | from tsv --flexible --noheaders --no-infer
        | rename value description
    }

    let zoxide_completer = {|spans|
      $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
    }

    # This completer will use carapace by default
    let external_completer = {|spans|
      let expanded_alias = scope aliases
      | where name == $spans.0
      | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # use zoxide completions for zoxide commands
        __zoxide_z | __zoxide_zi | z => $zoxide_completer
        _ => $carapace_completer
        } | do $in $spans
    }

    $env.config = {
      show_banner: false,
      completions: {
        external: {
          enable: true
          completer: $external_completer
        }
      }
    }

    # Preserve existing PATH and add our additional paths
    $env.PATH = ([
      "/usr/bin/env"
      "/run/current-system/sw/bin"
      $"($env.HOME)/.nix-profile/bin"
      "/nix/var/nix/profiles/default/bin"
      "/run/current-system/sw/bin"
      $"/etc/profiles/per-user/($env.USER)/bin"
      "/opt/homebrew/bin"
    ] | append ($env.PATH | default [] | split row (char esep)) | uniq)

    # Activate mise
    mise activate nu | str trim | nu -c $in

    # Activate atuin
    source ~/.cache/atuin/init.nu

    # Set all mise environment variables including PATH
    let mise_env = (mise env --json | from json)
    for entry in ($mise_env | columns) {
        if $entry == "PATH" {
            # Merge PATH entries, removing duplicates
            $env.PATH = (
                ($mise_env | get PATH | split row ":" | 
                append $env.PATH) | uniq
            )
        } else {
            load-env {($entry): ($mise_env | get $entry)}
        }
    }

    # Add keybinding for tmux session
    $env.config.keybindings = ($env.config.keybindings | default [] | append {
      name: create_tmux_session
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "if (which tmux | is-empty) { echo 'tmux is not installed' } else { if ('TMUX' not-in $env) { tmux new-session -A -s 'main' } }"
      }
    })
  '';

  shellAliases = {
    cd = "z";
    cat = "bat";
    grep = "batgrep";
    rg = "batgrep";
    man = "batman";
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
  };

  environmentVariables = {
    BAT_THEME = "base16";
    CARAPACE_BRIDGES = "argcomplete,inshellisense,cobra,click,urfavecli,yargs,kingpin,carapace";
    CARAPACE_MATCH = 1;
  };
} 
