{
  config,
  ...
}:
{
  flake.modules.hosts.x13.imports =
    # Import the nixos modules for the host `x13`.
    with (config.flake.modules.nixos);
    [
      base
      bluetooth
      desktop
      displaylink
      dev
      facter
      fwupd
      shell
      sound
      vpn
      virtualisation
    ]
    # Import the `nixosUsers` modules for the users `root` and `pol`.
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
          email
          facter
          games
          shell
          vpn
          work
        ];
      }
    ];
}
