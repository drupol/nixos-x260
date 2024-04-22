{
  config,
  lib,
  pkgs,
  ...
}:
{

  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = lib.mkForce true;
        "net.ipv6.conf.all.forwarding" = lib.mkForce true;
      };
    };
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_BE.UTF-8";
    LC_IDENTIFICATION = "fr_BE.UTF-8";
    LC_MEASUREMENT = "fr_BE.UTF-8";
    LC_MONETARY = "fr_BE.UTF-8";
    LC_NAME = "fr_BE.UTF-8";
    LC_NUMERIC = "fr_BE.UTF-8";
    LC_PAPER = "fr_BE.UTF-8";
    LC_TELEPHONE = "fr_BE.UTF-8";
    LC_TIME = "fr_BE.UTF-8";
  };

  # https://mastodon.online/@nomeata/109915786344697931
  documentation.nixos.enable = false;

  systemd.services.NetworkManager-wait-online.enable = false;

  environment.variables.EDITOR = "micro";
  environment.variables.VISUAL = "micro";
}
