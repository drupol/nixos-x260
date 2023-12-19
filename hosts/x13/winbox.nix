{ config
, lib
, pkgs
, ...
}: {

  environment.systemPackages = with pkgs; [
    winbox
  ];

  networking = {
    firewall.allowedUDPPorts = [ 5678 ];
  };

}
