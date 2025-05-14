{
  flake.modules = {
    nixos.vpn = {
      services.netbird = {
        enable = true;
      };
    };

    homeManager.vpn =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          netbird-ui
        ];
      };
  };
}
