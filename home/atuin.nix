{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = false;

  settings = {
    enter_accept = true;
    sync.records = true;
  };
}
