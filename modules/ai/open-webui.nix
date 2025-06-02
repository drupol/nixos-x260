{
  nixpkgs = {
    allowedUnfreePackages = [
      "open-webui"
    ];
  };

  flake.modules.nixos.ai = {
    services = {
      open-webui = {
        enable = true;
        host = "0.0.0.0";
        port = 8080;
        environment = {
          CONTENT_EXTRACTION_ENGINE = "tika";
          DEVICE_TYPE = "cpu";
          ENABLE_OLLAMA_API = "True";
          ENABLE_OPENAI_API = "True";
          ENABLE_RAG_HYBRID_SEARCH = "True";
          ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION = "False";
          ENABLE_RAG_WEB_SEARCH = "True";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
          OPENAI_API_BASE_URL = "http://127.0.0.1:8888/v1";
          OPENAI_API_KEY = "";
          PDF_EXTRACT_IMAGES = "True";
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "bge-m3:latest";
          RAG_EMBEDDING_MODEL_AUTO_UPDATE = "True";
          RAG_FILE_MAX_COUNT = "2";
          RAG_RERANKING_MODEL = "BAAI/bge-reranker-v2-m3";
          RAG_TEXT_SPLITTER = "token";
          RAG_WEB_SEARCH_ENGINE = "searxng";
          RAG_WEB_SEARCH_RESULT_COUNT = "5";
          RESET_CONFIG_ON_START = "True";
          SEARXNG_QUERY_URL = "http://127.0.0.1:3002/search?q=<query>";
          TIKA_SERVER_URL = "http://127.0.0.1:9998/";
          WEBUI_AUTH = "False";
          WEBUI_NAME = "LLM @ Home";
        };
      };

      caddy = {
        enable = true;
        virtualHosts."192.168.2.164:80".extraConfig = ''
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
    ];
  };
}
