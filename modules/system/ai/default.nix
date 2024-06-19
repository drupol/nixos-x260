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
  disabledModules = [ "services/misc/open-webui.nix" ];

  imports = [ "${inputs.nixpkgs-master}/nixos/modules/services/misc/open-webui.nix" ];

  options = {
    ai.enable = lib.mkEnableOption "ai";
  };

  config = lib.mkIf cfg.enable {
    services = {
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
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
          RAG_EMBEDDING_MODEL_AUTO_UPDATE = "True";
          RAG_RERANKING_MODEL_AUTO_UPDATE = "True";
          ENABLE_RAG_WEB_SEARCH = "True";
          ENABLE_RAG_WEB_LOADER_SSL_VERIFICATION = "False";
          RAG_WEB_SEARCH_ENGINE = "searxng";
          SEARXNG_QUERY_URL = "http://192.168.1.37/searx/search?q=<query>";
          RAG_WEB_SEARCH_RESULT_COUNT = "5";
        };
      };

      ollama = {
        enable = true;
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
