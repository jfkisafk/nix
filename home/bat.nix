{ pkgs, ... }: {
  enable = true;
  config = {
    map-syntax = [
      "*.jenkinsfile:Groovy"
      "*.props:Java Properties"
    ];
    theme = "Catppuccin Mocha";
  };
  themes = {
   "Catppuccin Mocha" = {
     src = pkgs.fetchFromGitHub {
       owner = "catppuccin";
       repo = "bat";
       rev = "main";
       sha256 = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
     };
     file = "themes/Catppuccin Mocha.tmTheme";
   };
 };
} 