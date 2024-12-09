{ pkgs, ... }: {
  packages = with pkgs.nerd-fonts; [
    blex-mono
    jetbrains-mono
    monaspace
    roboto-mono
    space-mono
  ];
}