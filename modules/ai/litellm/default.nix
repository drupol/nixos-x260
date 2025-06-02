{
  flake.modules.nixos.ai = {
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
            {
              model_name = "Gemini";
              litellm_params = {
                model = "gemini/gemini-2.5-pro-exp-03-25";
                api_key = "os.environ/GEMINI_API_KEY";
              };
            }
            {
              model_name = "mistral/open-mistral-nemo";
              litellm_params = {
                model = "mistral/open-mistral-nemo";
                api_key = "os.environ/MISTRAL_API_KEY";
              };
            }
          ];
        };
        environmentFile = "/home/pol/Code/drupol/litellm-secrets.env";
        openFirewall = true;
      };
    };
  };
}
