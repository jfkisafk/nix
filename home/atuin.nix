{ pkgs, ... }: {
  enable = true;

  settings = {
    enter_accept = true;
    sync.records = true;
    sync_address = "https://darkstar.dohne-hue.ts.net/atuin/sync";
    style = "compact";
    secrets_filter = true;
    ignored_commands = [
      "^cd"
      "^ls"
      "^vi"
    ];
    theme.name = "rose-pine";
  };

  themes.rose-pine = {
    theme.name = "rose-pine";
    colors = {
      AlertInfo = "#9ccfd8";
      AlertWarn = "#f6c177";
      AlertError = "#eb6f92";
      Annotation = "#6e6a86";
      Base = "#e0def4";
      Guidance = "#908caa";
      Important = "#eb6f92";
      Title = "#c4a7e7";
      Muted = "#6e6a86";
      SyntaxCommand = "#3e8fb0";
      SyntaxFlag = "#ea9a97";
      SyntaxString = "#9ccfd8";
      SyntaxVariable = "#c4a7e7";
      SyntaxOperator = "#e0def4";
      SyntaxComment = "#6e6a86";
    };
  };
}
