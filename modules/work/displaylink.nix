{
  flake.modules.nixos.displaylink = {
    services = {
      xserver = {
        videoDrivers = [ "displaylink" ];
      };
    };
  };

  nixpkgs.allowedUnfreePackages = [
    "displaylink"
  ];
}
