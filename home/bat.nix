{ pkgs, ... }: {
  enable = true;
  config = {
    map-syntax = [
      "*.jenkinsfile:Groovy"
      "*.props:Java Properties"
    ];
    theme = "rose-pine";
  };
  themes = {
   "rose-pine" = {
     src = pkgs.fetchFromGitHub {
       owner = "rose-pine";
       repo = "tm-theme";
       rev = "main";
       sha256 = "sha256-bQSGi9tuv8F4gHWqoJNOm2nTRt3XiJ/90EDz9D8/iIY=";
     };
     file = "dist/themes/rose-pine.tmTheme";
   };
 };
}
