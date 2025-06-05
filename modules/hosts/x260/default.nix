{
  config,
  ...
}:
{
  flake.modules.nixos."hosts/x260".imports =
    with (config.flake.modules.nixos);
    [
      # Modules
      base
      bluetooth
      desktop
      dev
      facter
      fwupd
      shell
      sound
      vpn

      # Users
      root
      pol
    ]
    # Specific Home-Manager modules
    ++ [
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
