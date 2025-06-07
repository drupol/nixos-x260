{
  unify.modules.work.nixos = {
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
