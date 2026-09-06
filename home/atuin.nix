{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = false;

  settings = {
    enter_accept = true;
    sync.records = true;
    sync_address = "http://darkstar.dohne-hue.ts.net:30530";
    style = "compact";
    secrets_filter = true;
    ignored_commands = [
      "^cd"
      "^ls"
      "^vi"
    ];
    theme.name = "rose-pine";
  };
}
