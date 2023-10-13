{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
    du-dust
    fd
    fish
    micro
    neofetch
    nix-your-shell
    p7zip
    procs
    tailscale
    tig
    wget
  ];
}
