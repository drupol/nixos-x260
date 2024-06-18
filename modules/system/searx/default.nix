{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.searx;
in
{
  options = {
    searx.enable = lib.mkEnableOption "searx";
  };

  config = lib.mkIf cfg.enable {
    services = {
      searx = {
        enable = true;
        settings = {
          server = {
            port = 3002;
            bind_address = "127.0.0.1";
            secret_key = "spotting-gumminess-chamomile-unsuited-purple";
            image_proxy = true;
            base_url = "/searx";
          };
        };
      };

      caddy = {
        enable = true;
        virtualHosts."192.168.1.37".extraConfig = ''
          handle_path /searx/* {
            reverse_proxy 127.0.0.1:3002
          }
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
