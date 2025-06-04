{
  config,
  ...
}:
{
  flake.modules.nixos."hosts/x13".imports =
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
    ++ [ config.flake.modules.nixos.root ]
    ++ [ config.flake.modules.nixos.pol ]
    ++ [
      # Import the home-manager modules for the user `pol` only.
      # TODO: Should we move this to the `nixos` pol's module or we leave it here?
      {
        home-manager.users.pol.imports = with config.flake.modules.homeManager; [
          base
          desktop
          dev
          email
          facter
          messaging
          games
          shell
          vpn
          work
        ];
      }
    ];
}
