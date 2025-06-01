{
  config,
  ...
}:
{
  flake.modules.hosts.nixos.imports =
    with (config.flake.modules.nixos);
    [
      base
      ai
      dev
      facter
      shell
      sshd
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
          dev
          facter
          shell
          vpn
        ];
      }
    ];
}
