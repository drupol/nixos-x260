{
  config,
  pkgs,
  self,
  host,
  ...
}: {
  environment.systemPackages = with pkgs; [
    any-nix-shell
    bat-extras.batman
    bottom # https://zaiste.net/posts/shell-commands-rust/
    cachix
    du-dust
    exa
    fd
    git
    gnupg
    procs
    ripgrep
    tig
    wget
  ];
}
