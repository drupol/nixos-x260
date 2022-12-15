{ buildVscodeMarketplaceExtension }:

{
  bmewburn.vscode-intelephense-client = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-intelephense-client";
      publisher = "bmewburn";
      version = "1.8.2";
      sha256 = "OvWdDQfhprQNve017pNSksMuCK3Ccaar5Ko5Oegdiuo=";
    };
  };
}
