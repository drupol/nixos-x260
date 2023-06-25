{ config
, pkgs
, self
, hostConfig
, ...
}: {
  imports = [
    self.inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${hostConfig.user}".imports = [
      self.inputs.plasma-manager.homeManagerModules.plasma-manager
      ../common/kdeplasma.nix
      ../common/home.nix
      ../common/starship.nix
      ../../modules/activation/profile-report-changes.nix
    ];
  };
}
