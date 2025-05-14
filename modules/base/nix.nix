{
  unify.modules.base.nixos =
    { pkgs, ... }:
    {
      nix = {
        # See https://discourse.nixos.org/t/24-05-add-flake-to-nix-path/46310/9
        # See https://hachyderm.io/@leftpaddotpy/112539055867932912
        channel.enable = false;
        settings.nix-path = [ "nixpkgs=${pkgs.path}" ];

        # From https://jackson.dev/post/nix-reasonable-defaults/
        extraOptions = ''
          connect-timeout = 5
          log-lines = 50
          min-free = 128000000
          max-free = 1000000000
          fallback = true
        '';
        optimise.automatic = true;
        settings = {
          trusted-users = [
            "root"
          ];
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          warn-dirty = false;
        };
      };
    };
}
