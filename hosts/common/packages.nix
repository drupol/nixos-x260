{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    any-nix-shell
    bat-extras.batman
    bottom # https://zaiste.net/posts/shell-commands-rust/
    cachix
    dina-font
    du-dust
    fd
    fira-code
    fira-code-symbols
    fish
    gnupg
    hack-font
    iosevka
    iosevka-comfy.comfy
    jetbrains-mono
    liberation_ttf
    neofetch
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "Hack" "JetBrainsMono"];})
    p7zip
    procs
    ripgrep
    tailscale
    tig
    wget
  ];
}
