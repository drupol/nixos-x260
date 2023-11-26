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
    publicUrl = "http://wiki.router.lan";
    forceHttps = false;
    storage.storageType = "local";
  };

  services.dex = {
    enable = true;
    settings = {
      issuer = "http://dex.router.lan";
      storage.type = "sqlite3";
      web.http = "127.0.0.1:5556";
      staticClients = [
        {
          id = "outline";
          name = "Outline Client";
          redirectURIs = [ "http://localhost:3000/auth/oidc.callback" ];
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

  services.caddy.virtualHosts."wiki.router.lan".extraConfig = ''
    tls internal
    reverse_proxy 127.0.0.1:3000
  '';
}
