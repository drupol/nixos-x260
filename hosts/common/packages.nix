{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
    du-dust
    fd
    fish
    git-absorb
    nh
    neofetch
    p7zip
    procs
    tailscale
    tig
    wget
  ];
}
