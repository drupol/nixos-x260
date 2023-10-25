{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
    du-dust
    fd
    fish
    helix
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
