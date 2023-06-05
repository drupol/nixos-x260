{
  config,
  pkgs,
  self,
  hostConfig,
  ...
}: {
  environment.systemPackages = with pkgs; [
    any-nix-shell
    bat
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
