{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    {
      services = {
        docling-serve = {
          enable = true;
          host = "0.0.0.0";
          port = 5001;
          package = pkgs.docling-serve.override {
            withUI = true;
            withTesserocr = true;
            withCPU = true;
            withRapidocr = true;
          };
          environment = {
            DOCLING_SERVE_ENABLE_UI = "True";
          };
          openFirewall = true;
        };
      };

      networking.firewall.allowedTCPPorts = [
        5001
      ];
    };
}
