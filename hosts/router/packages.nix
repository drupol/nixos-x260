{ config
, pkgs
, self
, hostConfig
, ...
}: {
  environment.systemPackages = with pkgs; [
    bat
    bat-extras.batman
    bottom # https://zaiste.net/posts/shell-commands-rust/
    cachix
    du-dust
    eza
    fd
    git
    gnupg
    procs
    ripgrep
    tig
    wget
  ];
}
