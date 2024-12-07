{ pkgs, ... }: {
  enable = true;

  extraConfig = ''
    $env.config = {
      show_banner: false
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
