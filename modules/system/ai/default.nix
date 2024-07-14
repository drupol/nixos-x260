{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ai;
in
{
  imports = [ "${inputs.nixpkgs-master}/nixos/modules/services/search/tika.nix" ];

  options = {
    ai.enable = lib.mkEnableOption "ai";
  };

  config = lib.mkIf cfg.enable {
    services = {
      tika = {
        enable = true;
        package = pkgs.master.tika;
      };

      ollama = {
        enable = true;
      };

      open-webui = {
        enable = true;
        package = pkgs.master.open-webui;
        port = 8080;
        environment = {
          WEBUI_AUTH = "False";
          ENABLE_OLLAMA_API = "True";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
          DEVICE_TYPE = "cpu";
          ENABLE_RAG_HYBRID_SEARCH = "True";
          RESET_CONFIG_ON_START = "True";
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
          RAG_EMBEDDING_MODEL_AUTO_UPDATE = "True";
          RAG_RERANKING_MODEL_AUTO_UPDATE = "True";
          RAG_RERANKING_MODEL = "mxbai-embed-large:latest";
          ENABLE_RAG_WEB_SEARCH = "True";
          ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION = "False";
          RAG_WEB_SEARCH_ENGINE = "searxng";
          SEARXNG_QUERY_URL = "http://127.0.0.1/searx/search?q=<query>";
          RAG_WEB_SEARCH_RESULT_COUNT = "5";
          CONTENT_EXTRACTION_ENGINE = "tika";
          TIKA_SERVER_URL = "http://127.0.0.1:9998/";
        };
      };

      caddy = {
        enable = true;
        virtualHosts."192.168.1.37".extraConfig = ''
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
