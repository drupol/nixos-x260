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
          use_default_settings = true;

          general = {
            privacypolicy_url = false;
            enable_metrics = true;
            debug = false;
          };

          server = {
            port = 3002;
            bind_address = "127.0.0.1";
            secret_key = "spotting-gumminess-chamomile-unsuited-purple";
            image_proxy = true;
            base_url = "/searx";
            limiter = false;
            public_instance = false;
          };

          search = {
            safe_search = 0; # 0 = None, 1 = Moderate, 2 = Strict
            formats = ["html" "json" "rss"];
            autocomplete = "google"; # "dbpedia", "duckduckgo", "google", "startpage", "swisscows", "qwant", "wikipedia" - leave blank to turn it off by default
            default_lang = "en";
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
