{ pkgs, ... }: {
  # Set up default shell
  postActivation.text = ''
    chsh -s /run/current-system/sw/bin/nu
  '';

  # Set up mise tools
  installMiseTools.text = ''
    # Set up mise tools
    tools=(
    "node@lts"
    "deno@2"
    "python@3"
    "java@corretto-23"
    "rust@stable"
    "kafka@apache"
    "go@1"
    "terraform@1"
    "poetry@1"
    "kubectl@1"
    "spectral@6"
    )

    for tool in "''${tools[@]}"; do
    if ! /run/current-system/sw/bin/mise current | grep -q "$(echo $tool | cut -d@ -f1)" || \
        /run/current-system/sw/bin/mise outdated --quiet | grep -q "$(echo $tool | cut -d@ -f1)"; then
        /run/current-system/sw/bin/mise use --global "$tool"
    fi
    done

    /run/current-system/sw/bin/mise upgrade
    /run/current-system/sw/bin/mise prune
  '';
}
