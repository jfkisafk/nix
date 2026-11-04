{ ... }: {
  enable = true;
  enableNushellIntegration = true;
  silent = true;
  config.whitelist = {
    prefix = [
      "/Volumes"
      "/private/tmp"
    ];
  };
}
