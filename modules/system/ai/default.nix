{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.ai;
in
{
  imports = [
    "${inputs.nixpkgs-master}/nixos/modules/services/misc/open-webui.nix"
  ];

  options = {
    ai.enable = lib.mkEnableOption "ai";
  };

  config = lib.mkIf cfg.enable {
    services = {
      open-webui = {
        enable = true;
        package = pkgs.master.open-webui;
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
