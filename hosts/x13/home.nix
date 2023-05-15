{ config
, pkgs
, self
, host
, ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${host.user}".imports = [
      self.inputs.plasma-manager.homeManagerModules.plasma-manager
      ../common/kdeplasma.nix
      ../common/home.nix
      ../../modules/activation/profile-report-changes.nix
    ];
  };
}
