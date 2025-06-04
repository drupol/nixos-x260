{
  config,
  ...
}:
{
  flake.modules.nixos.xeonixos.imports =
    with (config.flake.modules.nixos);
    [
      base
      desktop
      dev
      facter
      guacamole
      openssh
      shell
      virtualisation
      vpn
    ]
    ++ config.flake.modules.nixos.root.imports
    ++ config.flake.modules.nixos.pol.imports
    ++ [
      # Import the home-manager modules for the user `pol` only.
      # TODO: Should we move this to the `nixos` pol's module or we leave it here?
      {
        home-manager.users.pol.imports = with config.flake.modules.homeManager; [
          base
          desktop
          dev
          facter
          shell
          vpn
        ];
      }
    ];
}
