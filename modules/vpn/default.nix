{
  unify.modules.vpn = {
    nixos = {
      services.netbird = {
        enable = true;
      };
    };

    home =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          netbird-ui
        ];
      };
  };
}
