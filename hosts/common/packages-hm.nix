{ config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    cachix
    du-dust
    fd
    fish
    neofetch
    p7zip
    procs
    tig
    wget
  ];
}
