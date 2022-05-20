{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      any-nix-shell
      ark
      bat
      bottom # https://zaiste.net/posts/shell-commands-rust/
      cachix
      difftastic
      du-dust
      exa
      fd
      fish
      git
      gnupg
      htop
      neofetch
      p7zip
      pass
      plantuml
      procs
      tig
      wget
    ];
}
