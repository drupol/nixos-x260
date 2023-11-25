{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    cachix
    du-dust
    fd
    fish
    neofetch
    p7zip
    procs
    tailscale
    tig
    wget
  ];
}
