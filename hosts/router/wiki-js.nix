{ pkgs
, config
, ...
}:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "wikijs" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    ensureUsers = [
      {
        name = "wikijs";
        ensureDBOwnership = true;
      }
    ];
  };

  services.wiki-js = {
    enable = true;
    settings = {
      bindIp = "127.0.0.1";
      port = 3000;

      db = {
        db   = "wikijs";
        user = "wikijs";
        host = "/run/postgresql";
      };
    };
  };

  services.caddy.virtualHosts."wiki.router.lan".extraConfig = ''
    tls internal
    reverse_proxy http://127.0.0.1:3000
  '';
}
