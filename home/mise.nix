{ pkgs, ... }: {
  enable = true;
  enableMutableConfig = true;
  globalConfig = {
    settings.python.compile = false;
    tools = {
      node = "lts";
      deno = "2";
      dotnet = "10";
      bun = "1";
      yarn = "4";
      python = "3";
      poetry = "1";
      java = "corretto-26";
      rust = "stable";
      go = "1";
      spectral = "6";
      terraform = "1";
    };
  };
}
