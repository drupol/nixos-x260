{ pkgs, callpackage, ... }: {
  services = {
    caddy.virtualHosts."code.nixos.lan".extraConfig = ''
      tls internal
      reverse_proxy http://127.0.0.1:3000
    '';
    caddy.virtualHosts."openvscode.nixos.lan".extraConfig = ''
      tls internal
      reverse_proxy http://127.0.0.1:4000
    '';
    code-server = {
      package = pkgs.master.code-server;
      enable = true;
      host = "127.0.0.1";
      port = 3000;
      user = "pol";
      auth = "none";
      userDataDir = "/home/pol/.config/Code/";
      extensionsDir = "/home/pol/.vscode/extensions/";
    };
    openvscode-server = {
      package = callpackage ./openvscode-server-insiders.nix {};
      withoutConnectionToken = true;
      enable = true;
      host = "127.0.0.1";
      port = 4000;
      user = "pol";
      userDataDir = "/home/pol/.config/Code/";
      extensionsDir = "/home/pol/.vscode/extensions/";
    };
  };
}
