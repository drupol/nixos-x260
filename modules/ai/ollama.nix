{
  flake.modules.nixos.ai = {
    services = {
      ollama = {
        enable = true;
        environmentVariables = {
          "OLLAMA_FLASH_ATTENTION" = "true";
          "OLLAMA_KV_CACHE_TYPE" = "q8_0";
        };
      };
    };
  };
}
