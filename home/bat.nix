{ pkgs, ... }: {
  enable = true;
  config = {
    map-syntax = [
      "*.jenkinsfile:Groovy"
      "*.props:Java Properties"
    ];
    theme = "base16";
  };
} 