{
  config,
  ...
}:
{
  flake.modules.hosts.xeonixos.imports =
    with (config.flake.modules.nixos);
    [
      base
      desktop
      dev
      facter
      guacamole
      shell
      sshd
      virtualisation
      vpn
    ]
    ++ config.flake.modules.nixosUsers.root.imports
    ++ config.flake.modules.nixosUsers.pol.imports
    ++ [
      # Import the home-manager modules for the user `pol` only.
      # TODO: Should we move this to the `nixosUsers` pol's module or we leave it here?
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
