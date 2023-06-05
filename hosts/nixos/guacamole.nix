{ config, lib, pkgs, ... }:

{
  services.guacamole = {
    enable = true;
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

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";

  services.caddy.virtualHosts."remote.nixos.lan".extraConfig = ''
    tls internal
    redir / /guacamole/ 308
    reverse_proxy nixos.lan:8080 {
        flush_interval -1
    }
  '';
}
