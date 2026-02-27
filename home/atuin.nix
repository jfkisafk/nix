{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = false;

  settings = {
    enter_accept = true;
    sync.records = true;
    style = "compact";
    secrets_filter = true;
    ignored_commands = [
      "^cd"
      "^ls"
      "^vi"
    ];
  };
}
