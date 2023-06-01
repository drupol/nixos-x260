{
  pkgs,
  ...
}: {
  services = {
    caddy.virtualHosts."code.nixos.lan".extraConfig = ''
      tls internal
      reverse_proxy http://127.0.0.1:3000
    '';
    code-server = {
      package = pkgs.nixpkgs-master.code-server;
      enable = true;
      host = "127.0.0.1";
      port = 3000;
      user = "pol";
      auth = "none";
      userDataDir = "/home/pol/.config/Code/";
      extensionsDir = "/home/pol/.vscode/extensions/";
    };
  };
}
