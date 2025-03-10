{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.ai;
in
{
  imports = [
    "${inputs.litellm}/nixos/modules/services/misc/litellm.nix"
  ];

  config = lib.mkIf cfg.enable {
    services = {
      litellm = {
        enable = true;
        package = (
          pkgs.master.python3Packages.litellm.overridePythonAttrs (oldAttrs: {
            dependencies =
              (oldAttrs.dependencies or [ ])
              ++ pkgs.master.python3Packages.litellm.optional-dependencies.proxy
              ++ pkgs.master.python3Packages.litellm.optional-dependencies.extra_proxy;
          })
        );
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
          ];
        };
        environmentFile = ./secrets.env;
        openFirewall = true;
      };
    };
  };
}
