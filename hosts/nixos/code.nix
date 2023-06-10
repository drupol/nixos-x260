{ pkgs, ... }: {
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
      package = (pkgs.callPackage ./openvscode-server-insiders.nix {
        nodejs = pkgs.nodejs_16;
        inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa Security;
        inherit (pkgs.darwin) cctools;
      });
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
