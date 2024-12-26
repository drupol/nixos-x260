{ ... }:
{
  services.guacamole-server = {
    enable = true;
    host = "127.0.0.1";
    userMappingXml = ./guacamole/user-mapping.xml;
  };

  services.guacamole-client = {
    enable = true;
    settings = {
      guacd-port = 4822;
      guacd-hostname = "localhost";
    };
  };

  services.caddy.enable = true;
  services.caddy.virtualHosts."192.168.2.133".extraConfig = ''
    tls internal
    handle_path /* {
      rewrite * /guacamole{path}
      reverse_proxy 127.0.0.1:8080 {
         flush_interval -1
      }
    }
  '';

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;
  };
}
