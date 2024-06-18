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
          ENABLE_OLLAMA_API = "True";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
          WEBUI_AUTH = "False";
          DEVICE_TYPE = "cpu";
          ENABLE_RAG_HYBRID_SEARCH = "True";
          RAG_EMBEDDING_ENGINE = "ollama";
          RAG_EMBEDDING_MODEL = "mxbai-embed-large:latest";
          RAG_EMBEDDING_MODEL_AUTO_UPDATE = "True";
          RAG_RERANKING_MODEL_AUTO_UPDATE = "True";
        };
      };

      ollama = {
        enable = true;
      };

      caddy = {
        enable = true;
        virtualHosts."192.168.1.37".extraConfig = ''
          handle_path /ai/* {
            reverse_proxy 127.0.0.1:8080
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
