{
  config,
  ...
}:
{
  flake.modules.nixos."hosts/nixos".imports =
    with (config.flake.modules.nixos);
    [
      # Modules
      base
      ai
      dev
      facter
      openssh
      shell
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
          dev
          facter
          shell
          vpn
        ];
      }
    ];
}
