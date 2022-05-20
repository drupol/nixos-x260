{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      any-nix-shell
      ark
      bottom # https://zaiste.net/posts/shell-commands-rust/
      cachix
      du-dust
      fd
      fish
      gnupg
      neofetch
      p7zip
      plantuml
      procs
      tig
      wget
    ];
}
