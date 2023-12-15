{ config
, lib
, pkgs
, ...
}: {

  environment.systemPackages = with pkgs; [
    (winbox.override {wine = pkgs.wineWowPackages.stable;})
  ];

  networking = {
    firewall.allowedUDPPorts = [ 5678 ];
  };

}
