{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (pkgs.hiPrio uutils-coreutils-noprefix)
  ];
}
