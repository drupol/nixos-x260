{ pkgs
, config
, ...
}: {
  networking = {
    firewall = {
      allowedTCPPorts = [ 3000 5556 ];
    };
  };

  services.outline = {
    enable = true;
    publicUrl = "https://wiki.router.lan";
    storage.storageType = "local";
    enableUpdateCheck = false;
    oidcAuthentication = {
      # Parts taken from
      # http://dex.localhost/.well-known/openid-configuration
      authUrl = "https://dex.router.lan/auth";
      tokenUrl = "https://dex.router.lan/token";
      userinfoUrl = "https://dex.router.lan/userinfo";
      clientId = "outline";
      clientSecretFile = (builtins.elemAt config.services.dex.settings.staticClients 0).secretFile;
      scopes = [ "openid" "email" "profile" ];
      usernameClaim = "preferred_username";
      displayName = "Dex";
    };
  };

  services.dex = {
    enable = true;
    settings = {
      issuer = "https://dex.router.lan";
      storage.type = "sqlite3";
      web.http = "127.0.0.1:5556";
      staticClients = [
        {
          id = "outline";
          name = "Outline Client";
          redirectURIs = [ "https://wiki.router.lan/auth/oidc.callback" ];
          secretFile = "${pkgs.writeText "outline-oidc-secret" "test123"}";
        }
      ];
      connectors = [
        {
          type = "mockPassword";
          id = "mock";
          name = "Example";
          config = {
            username = "admin";
            password = "password";
          };
        }
      ];
    };
  };

  services.caddy.virtualHosts."dex.router.lan".extraConfig = ''
    tls internal
    reverse_proxy 127.0.0.1:5556
  '';

  services.caddy.virtualHosts."wiki.router.lan".extraConfig = ''
    tls internal
    reverse_proxy 127.0.0.1:3000
  '';
}
