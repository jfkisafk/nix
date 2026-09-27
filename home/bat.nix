{ pkgs, ... }: {
  enable = true;
  extraPackages = with pkgs.bat-extras; [ batman batgrep batwatch batpipe ];
  config = {
    map-syntax = [
      "*.jenkinsfile:Groovy"
      "*.props:Java Properties"
    ];
    theme = "rose-pine";
  };
  themes = {
    "rose-pine" = {
      src = pkgs.runCommand "rose-pine-theme-patched" { } ''
        mkdir -p $out/dist
        sed \
          -e 's/#ebbcba/#ea9a97/g' \
          -e 's/#31748f/#3e8fb0/g' \
          ${pkgs.fetchFromGitHub {
            owner = "rose-pine";
            repo = "tm-theme";
            rev = "6d556734541ccb04172e81fd58de4a35fff72d19";
            sha256 = "sha256-5+fG21KbB7bdPvszkz9Ftl6fCDGs17fJNTAXFRFWZGo=";
          }}/dist/rose-pine.tmTheme > $out/dist/rose-pine.tmTheme
      '';
      file = "dist/rose-pine.tmTheme";
    };
  };
}
