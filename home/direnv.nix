{ pkgs, ... }: {
  enable = true;
  enableNushellIntegration = true;
  mise.enable = true;
  silent = true;
  config.whitelist = {
    prefix = [ "/Volumes" "/private/tmp" ];
  };
} 