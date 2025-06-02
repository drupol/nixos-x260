{
  inputs,
  ...
}:
{
  flake.modules = {
    homeManager.desktop =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          inputs.nur.overlays.default
        ];

        programs.firefox =
          let
            defaultFont = "Aporetic Sans Mono";
          in
          {
            enable = true;
            nativeMessagingHosts = [
              pkgs.browserpass
            ];
            profiles.default = {
              id = 0;
              isDefault = true;
              name = "Default";
              extensions.packages = [
                pkgs.nur.repos.rycee.firefox-addons.browserpass
                # pkgs.nur.repos.rycee.firefox-addons.bypass-paywalls-clean
                pkgs.nur.repos.rycee.firefox-addons.enhancer-for-youtube
                pkgs.nur.repos.rycee.firefox-addons.private-relay
                pkgs.nur.repos.rycee.firefox-addons.foxyproxy-standard
                pkgs.nur.repos.rycee.firefox-addons.french-dictionary
                pkgs.nur.repos.rycee.firefox-addons.istilldontcareaboutcookies
                pkgs.nur.repos.rycee.firefox-addons.kristofferhagen-nord-theme
                pkgs.nur.repos.rycee.firefox-addons.languagetool
                pkgs.nur.repos.rycee.firefox-addons.multi-account-containers
                pkgs.nur.repos.rycee.firefox-addons.privacy-badger
                pkgs.nur.repos.rycee.firefox-addons.refined-saved-replies
                pkgs.nur.repos.rycee.firefox-addons.simple-tab-groups
                pkgs.nur.repos.rycee.firefox-addons.tournesol
                pkgs.nur.repos.rycee.firefox-addons.ublock-origin
                pkgs.nur.repos.rycee.firefox-addons.violentmonkey
              ];
              search = {
                default = "google";
                force = true;
                engines = {
                  "autonomous-system-number-search" = {
                    urls = [ { template = "https://bgp.tools/search?q={searchTerms}"; } ];
                    icon = "https://bgp.tools/favicon-32x32.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = [ "@asn" ];
                  };

                  "nix-packages" = {
                    urls = [
                      {
                        template = "https://search.nixos.org/packages";
                        params = [
                          {
                            name = "type";
                            value = "packages";
                          }
                          {
                            name = "query";
                            value = "{searchTerms}";
                          }
                        ];
                      }
                    ];

                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    definedAliases = [ "@np" ];
                  };

                  "nixpkgs-prs" = {
                    urls = [ { template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}"; } ];
                    icon = "https://nixos.org/favicon.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = [ "@npr" ];
                  };

                  "nixos-wiki" = {
                    urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
                    icon = "https://wiki.nixos.org/favicon.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = [ "@nw" ];
                  };

                  "noogle-dev-search" = {
                    urls = [ { template = "https://noogle.dev/?term=%22{searchTerms}%22"; } ];
                    icon = "https://noogle.dev/favicon.png";
                    updateInterval = 24 * 60 * 60 * 1000; # every day
                    definedAliases = [
                      "@ngd"
                      "@nog"
                    ];
                  };

                  "bing".metaData.hidden = true;
                  "duckduckgo".metaData.hidden = true;
                  "amazonnl".metaData.hidden = true;
                  "ebay".metaData.hidden = true;
                  "google".metaData.alias = "@g";
                };
              };
              settings = {
                "app.update.auto" = false;
                "browser.aboutConfig.showWarning" = false;
                "browser.urlbar.update2.engineAliasRefresh" = true;
                "browser.shell.checkDefaultBrowser" = false;
                "browser.startup.homepage" = "";
                "cookiebanners.service.mode" = 2;
                # Enable HTTPS-Only Mode
                "dom.security.https_only_mode" = true;
                "dom.security.https_only_mode_ever_enabled" = true;
                # Privacy settings
                "privacy.donottrackheader.enabled" = true;
                "privacy.trackingprotection.enabled" = true;
                "privacy.trackingprotection.socialtracking.enabled" = true;
                "privacy.partition.network_state.ocsp_cache" = true;
                # Disable all sorts of telemetry
                "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                "browser.newtabpage.activity-stream.telemetry" = false;
                "browser.fullscreen.autohide" = false;
                "browser.newtabpage.activity-stream.topSitesRows" = 0;
                "browser.urlbar.quickactions.enabled" = true;
                "browser.safebrowsing.malware.enabled" = false;
                "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter";
                "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
                "browser.urlbar.trimURLs" = false;
                "browser.ping-centre.telemetry" = false;
                "browser.urlbar.suggest.bookmark" = false;
                "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
                "browser.urlbar.suggest.quicksuggest.sponsored" = false;
                "browser.urlbar.suggest.searches" = false;
                "toolkit.telemetry.archive.enabled" = false;
                "toolkit.telemetry.bhrPing.enabled" = false;
                "toolkit.telemetry.enabled" = false;
                "toolkit.telemetry.firstShutdownPing.enabled" = false;
                "toolkit.telemetry.hybridContent.enabled" = false;
                "toolkit.telemetry.newProfilePing.enabled" = false;
                "toolkit.telemetry.reportingpolicy.firstRun" = false;
                "toolkit.telemetry.shutdownPingSender.enabled" = false;
                "toolkit.telemetry.unified" = false;
                "toolkit.telemetry.updatePing.enabled" = false;

                # As well as Firefox 'experiments'
                "experiments.activeExperiment" = false;
                "experiments.enabled" = false;
                "experiments.supported" = false;
                "network.allow-experiments" = false;
                # Disable Pocket Integration
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                "extensions.pocket.enabled" = false;
                "extensions.pocket.api" = "";
                "extensions.pocket.oAuthConsumerKey" = "";
                "extensions.pocket.showHome" = false;
                "extensions.pocket.site" = "";
                # Allow copy to clipboard
                "dom.events.asyncClipboard.clipboardItem" = true;
                "trailhead.firstrun.didSeeAboutWelcome" = true;
                "widget.use-xdg-desktop-portal.file-picker" = 1;
                "widget.use-xdg-desktop-portal.location" = 1;
                "widget.use-xdg-desktop-portal.mime-handler" = 1;
                "widget.use-xdg-desktop-portal.open-uri" = 1;
                "widget.use-xdg-desktop-portal.settings" = 1;

                "privacy.donottrackheader.value" = 1;
                "findbar.modalHighlight" = true;
                "datareporting.healthreport.uploadEnabled" = false;

                # override fonts
                "font.minimum-size.x-western" = 12;
                "font.size.fixed.x-western" = 14;
                "font.size.monospace.x-western" = 14;
                "font.size.variable.x-western" = 14;
                "font.name.monospace.x-western" = "${defaultFont}";
                "font.name.sans-serif.x-western" = "${defaultFont}";
                "font.name.serif.x-western" = "${defaultFont}";
                "browser.display.use_document_fonts" = 0;
              };
            };
          };
      };
  };
}
