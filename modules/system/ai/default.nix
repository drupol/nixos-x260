{
  config,
  lib,
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
    services = {
      open-webui = {
        enable = true;
        openFirewall = true;
        host = "0.0.0.0";
        environment = {
          ENABLE_OLLAMA_API = "True";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
          HF_HOME = "/var/lib/open-webui/";
          SENTENCE_TRANSFORMERS_HOME = "/var/lib/open-webui/";
          WEBUI_AUTH = "False";
          DEVICE_TYPE = "cpu";
          ENABLE_RAG_HYBRID_SEARCH = "True";
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
        };
      };

      ollama = {
        enable = true;
      };
    };
  };


}
