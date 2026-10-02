{ pkgs, ... }: {
  enable = true;
  # The module's Nushell hook binds ctrl+t and ctrl+r, which herdr and atuin already own.
  enableNushellIntegration = false;
  settings.ui.theme = "rose-pine-transparent";
  # Built-in rose-pine minus its background, so Ghostty's shows through; theme_overrides can't unset a color.
  themes.rose-pine-transparent = builtins.removeAttrs (builtins.fromTOML (
    builtins.readFile "${pkgs.television.src}/themes/rose-pine.toml"
  )) [ "background" ];
  # Community channels read from the package source, so they always match the tv version.
  channels =
    pkgs.lib.genAttrs [
      "aws-buckets"
      "aws-instances"
      "aws-profiles"
      "channels"
      "docker-containers"
      "gh-issues"
      "gh-prs"
      "git-reflog"
      "git-stash"
      "k8s-contexts"
      "k8s-deployments"
      "k8s-pods"
      "k8s-services"
      "nu-history"
      "procs"
      "ssh-hosts"
      "todo-comments"
    ] (name: builtins.fromTOML (builtins.readFile "${pkgs.television.src}/cable/unix/${name}.toml"))
    // {
      # The community alias channel runs `$SHELL -ic alias`, which Nushell doesn't support; -l loads config.nu.
      alias = {
        metadata = {
          name = "alias";
          description = "Nushell aliases and their expansions";
        };
        source = {
          command = "nu -l -c 'scope aliases | each {|a| $\"($a.name)\\t($a.expansion)\" } | str join (char nl)'";
          display = "{split:\t:0}  {split:\t:1}";
          output = "{split:\t:0}";
        };
      };
    };
}
