{ config, pkgs, lib, ... }:


{
    # Firefox
    programs = {
        firefox = {
            enable = true;
            languagePacks = [ "fr" "en-US" ];

            /* ---- POLICIES ---- */
            # Check about:policies#documentation for options.
            policies = {
                DisableTelemetry = true;
                DisableFirefoxStudies = true;
                EnableTrackingProtection = {
                    Value= true;
                    # Locked = true;
                    Cryptomining = true;
                    Fingerprinting = true;
                };
                DisablePocket = true;
                # DisableFirefoxAccounts = true;
                # DisableAccounts = true;
                # DisableFirefoxScreenshots = true;
                # OverrideFirstRunPage = "";
                # OverridePostUpdatePage = "";
                DontCheckDefaultBrowser = true;
                DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
                # DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
                # SearchBar = "unified"; # alternative: "separate"

                /* ---- EXTENSIONS ---- */
                # Check about:support for extension/add-on ID strings.
                # Valid strings for installation_mode are "allowed", "blocked",
                # "force_installed" and "normal_installed".
                # Extensions = {
                #     Install = [
                #         "uBlock0@raymondhill.net"
                #         "{446900e4-71c2-419f-a6a7-df9c091e268b}"
                #         "CookieAutoDelete@kennydo.com"
                #     ];
                # };
                # ExtensionSettings = {
                #     # uBlock Origin
                #     "uBlock0@raymondhill.net" = {
                #         installation_mode = "force_installed";
                #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                #     };
                #     # Bitwarden
                #     "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                #         installation_mode = "force_installed";
                #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                #     };
                #     # Cookie AutoDelete
                #     "CookieAutoDelete@kennydo.com" = {
                #         installation_mode = "force_installed";
                #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi";
                #     };
                #     ExtensionUpdate = true;
                # };

                /* ---- PREFERENCES ---- */
                # Check about:config for options.
                Preferences = { 
                    "intl.accept_languages" = "fr-fr,en-us,en";
                    "intl.locale.requested" = "fr,en-US";
                    # "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
                    "extensions.pocket.enabled" = false;
                    # "extensions.screenshots.disabled" = true;
                    "browser.topsites.contile.enabled" = false;
                    "browser.formfill.enable" = false;
                    # "browser.search.suggest.enabled" = false;
                    # "browser.search.suggest.enabled.private" = false;
                    # "browser.urlbar.suggest.searches" = false;
                    # "browser.urlbar.showSearchSuggestionsFirst" = false;
                    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                    "browser.newtabpage.activity-stream.feeds.snippets" = false;
                    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                    # "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
                    # "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
                    # "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
                    "browser.newtabpage.activity-stream.showSponsored" = false;
                    "browser.newtabpage.activity-stream.system.showSponsored" = false;
                    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                    "network.trr.mode" = 2;
                    "network.trr.custom_uri" = "https://dns.adguard-dns.com/dns-query";
                    "network.trr.uri" = "https://dns.adguard-dns.com/dns-query";
                };
            };
        };
    };
}
