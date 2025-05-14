{
  unify.modules.displaylink.nixos = {
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
