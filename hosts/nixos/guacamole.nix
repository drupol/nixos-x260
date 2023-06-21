{ config
, lib
, pkgs
, ...
}: {
  services.guacamole-server = {
    enable = true;
    package = pkgs.guacamole-nixos.guacamole-server;
    host = "127.0.0.1";
    userMapping = ''
      <user-mapping>
          <authorize username="guacadmin" password="guacadmin">
            <connection name="nixos.lan rdp">
                <protocol>rdp</protocol>
                <param name="hostname">127.0.0.1</param>
                <param name="port">3389</param>
                <param name="ignore-cert">true</param>
            </connection>

            <connection name="nixos.lan ssh">
                <protocol>ssh</protocol>
                <param name="hostname">127.0.0.1</param>
                <param name="port">22</param>
            </connection>
          </authorize>
      </user-mapping>
    '';
  };

  services.guacamole-client = {
    enable = true;
    package = pkgs.guacamole-nixos.guacamole-client;
    settings = {
      guacd-port = 4822;
      guacd-hostname = "localhost";
    };
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";

  services.caddy.virtualHosts."remote.nixos.lan".extraConfig = ''
    tls internal
    handle_path /* {
      rewrite * /guacamole{path}
      reverse_proxy nixos.lan:8080 {
         flush_interval -1
      }
    }
  '';
}
