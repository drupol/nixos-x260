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
  options = {
    ai.enable = lib.mkEnableOption "ai";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # If Tesseract is available, Tika will use it.
      # To fix upstream
      pkgs.tesseract
    ];

    services = {
      tika = {
        enable = true;
        package = pkgs.tika;
      };

      ollama = {
        enable = true;
      };

      open-webui = {
        enable = true;
        package = pkgs.master.open-webui;
        port = 8080;
        environment = {
          CONTENT_EXTRACTION_ENGINE = "tika";
          DEVICE_TYPE = "cpu";
          DOCS_DIR = "/var/lib/open-webui/uploads";
          ENABLE_OLLAMA_API = "True";
          ENABLE_RAG_HYBRID_SEARCH = "True";
          ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION = "False";
          ENABLE_RAG_WEB_SEARCH = "True";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
          PDF_EXTRACT_IMAGES = "True";
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
          RAG_EMBEDDING_MODEL_AUTO_UPDATE = "True";
          RAG_RERANKING_MODEL = "BAAI/bge-reranker-v2-m3";
          RAG_RERANKING_MODEL_AUTO_UPDATE = "True";
          RAG_WEB_SEARCH_ENGINE = "searxng";
          RAG_WEB_SEARCH_RESULT_COUNT = "5";
          RESET_CONFIG_ON_START = "True";
          SEARXNG_QUERY_URL = "http://127.0.0.1:3002/search?q=<query>";
          TIKA_SERVER_URL = "http://127.0.0.1:9998/";
          WEBUI_AUTH = "False";
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
