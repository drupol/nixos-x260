{
  flake.modules.homeManager.email =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kdePackages.accounts-qt
        kdePackages.kaccounts-integration
        kdePackages.kaccounts-providers
        kdePackages.kaddressbook
        kdePackages.kauth
        kdePackages.kmail
        kdePackages.kmail-account-wizard
        kdePackages.kmailtransport
        kdePackages.kontact
        kdePackages.korganizer
      ];
    };
}
