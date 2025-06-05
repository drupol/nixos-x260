{
  config,
  ...
}:
{
  flake.modules.nixos."hosts/xeonixos".imports =
    with (config.flake.modules.nixos);
    [
      # Modules
      base
      desktop
      dev
      facter
      guacamole
      openssh
      shell
      virtualisation
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
