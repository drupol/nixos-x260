{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    any-nix-shell
    bat-extras.batman
    bottom # https://zaiste.net/posts/shell-commands-rust/
    cachix
    du-dust
    fd
    fish
    gnupg
    neofetch
    p7zip
    procs
    ripgrep
    tig
    wget
  ];
}
