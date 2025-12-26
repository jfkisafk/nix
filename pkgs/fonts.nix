{ pkgs, ... }: {
  packages = with pkgs.nerd-fonts; [
    # agave
    anonymice # no ligatures
    # aurulent-sans-mono
    bigblue-terminal # no ligatures but cool
    # bitstream-vera-sans-mono
    # blex-mono
    caskaydia-cove # some ligatures
    # caskaydia-mono
    # code-new-roman
    commit-mono # no ligatures
    # daddy-time-mono
    # dejavu-sans-mono
    # departure-mono
    # droid-sans-mono
    # envy-code-r
    fantasque-sans-mono # ligatures
    fira-code # ligatures
    # fira-mono
    geist-mono # ligatures, default
    # hasklug
    # im-writing
    # inconsolata
    # intone-mono
    iosevka # ligatures, breaks starship
    jetbrains-mono # ligatures
    lilex # ligatures
    martian-mono # ligatures, heavy padding
    monaspace # no ligatures, Xenon/Neon
    # monoid
    # monofur
    # mononoki
    noto # no ligatures
    # overpass
    # profont
    recursive-mono # ligatures; linear/semi-casual
    # roboto-mono
    # sauce-code-pro
    # shure-tech-mono
    space-mono # no ligatures
    # ubuntu-mono
    victor-mono # ligatures
    zed-mono # ligatures, breaks starship
  ];
}
