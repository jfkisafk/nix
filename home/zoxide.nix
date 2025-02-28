{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = true;
  options = [
    "--cmd=cd"
  ];
}
