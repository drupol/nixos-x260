{
  unify.modules.vpn.nixos = {
    services.netbird = {
      enable = true;
    };
  };

  unify.modules.vpn.home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        netbird-ui
        ktailctl
      ];
    };
}
