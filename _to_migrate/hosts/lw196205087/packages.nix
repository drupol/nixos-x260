{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bottom # https://zaiste.net/posts/shell-commands-rust/
    cachix
    dina-font
    du-dust
    fd
    fira-code
    fira-code-symbols
    fish
    gnupg
    hack-font
    jetbrains-mono
    liberation_ttf
    neofetch
    p7zip
    procs
    ripgrep
    wget

    element-desktop
    graphviz
    jetbrains.phpstorm
    tdesktop
    teams
  ];
}
