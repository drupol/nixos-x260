{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    any-nix-shell
    bat-extras.batman
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
    netavark
    p7zip
    procs
    ripgrep
    tig
    wget
  ];
}
