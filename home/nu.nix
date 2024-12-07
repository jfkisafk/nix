{ pkgs, ... }: {
  enable = true;

  extraConfig = ''
    $env.config = {
      show_banner: false
    }

    $env.PATH = ($env.PATH | 
      split row (char esep) | 
      prepend /usr/bin/env |
      prepend /run/current-system/sw/bin |
      prepend $"($env.HOME)/.nix-profile/bin" |
      prepend "/nix/var/nix/profiles/default/bin" |
      prepend "/run/current-system/sw/bin" |
      prepend "/etc/profiles/per-user/$env.USER/bin" |
      append /opt/homebrew/bin)

    # Activate mise
    mise activate nu | str trim | nu -c $in

    # Set all mise environment variables including PATH
    let mise_env = (mise env --json | from json)
    for entry in ($mise_env | columns) {
        if $entry == "PATH" {
            $env.PATH = ($mise_env | get PATH | split row ":" | 
                append ($env.PATH | split row (char esep)))
        } else {
            load-env {($entry): ($mise_env | get $entry)}
        }
    }
  '';
  shellAliases = {
    cd = "z";
    cat = "bat";
    grep = "batgrep";
    rg = "batgrep";
    man = "batman";
  };
  environmentVariables = {
    BAT_THEME = "base16";
  };
} 
