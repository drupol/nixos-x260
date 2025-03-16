{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.ai;
in
{
  imports = [
    "${inputs.nixpkgs-master}/nixos/modules/services/misc/litellm.nix"
  ];

  config = lib.mkIf cfg.enable {
    services = {
      litellm = {
        enable = true;
        host = "0.0.0.0";
        port = 8888;
        settings = {
          model_list = [
            {
              model_name = "*";
              litellm_params = {
                model = "openai/*";
                api_key = "os.environ/OPENAI_API_KEY";
              };
            }
            {
              model_name = "gpt-4o";
              litellm_params = {
                model = "openai/gpt-4o";
                api_key = "os.environ/OPENAI_API_KEY";
              };
            }
            {
              model_name = "deepseek-v3";
              litellm_params = {
                model = "github/deepseek-v3";
                api_key = "os.environ/GITHUB_API_KEY";
              };
            }
            {
              model_name = "deepseek-r1";
              litellm_params = {
                model = "github/deepseek-r1";
                api_key = "os.environ/GITHUB_API_KEY";
              };
            }
            {
              model_name = "Llama-3.3-70B-Instruct";
              litellm_params = {
                model = "github/Llama-3.3-70B-Instruct";
                api_key = "os.environ/GITHUB_API_KEY";
              };
            }
          ];
        };
        environmentFile = "/home/pol/Code/drupol/nixos-x260/secrets.env";
        openFirewall = true;
      };
    };
  };
}
