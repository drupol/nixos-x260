{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
  ];
}
