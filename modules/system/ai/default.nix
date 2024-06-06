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
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          HF_HOME = "/var/lib/open-webui/";
          SENTENCE_TRANSFORMERS_HOME = "/var/lib/open-webui/";
          WEBUI_AUTH = "False";
        };
      };

      ollama = {
        enable = true;
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [
          8080
        ];
      };
    };
  };


}
