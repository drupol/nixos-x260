{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    any-nix-shell
    bat-extras.batman
    bottom # https://zaiste.net/posts/shell-commands-rust/
    cachix
    dina-font
    du-dust
    fd
    fish
    gnupg
    iosevka
    iosevka-comfy.comfy
    neofetch
    nerdfonts
    p7zip
    procs
    ripgrep
    tailscale
    tig
    wget
  ];
}
