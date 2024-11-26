{ config, pkgs, lib, inputs, ... }:

let
  inherit (builtins) toJSON;
  inherit (lib.attrsets) attrValues mapAttrsToList;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.strings) concatStrings;
  
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  
  cfg = config.modules.home.gnome.firefox;

in {
  options = {
    modules.home.firefox = let
      inherit (lib.options) mkEnableOption;
      inherit (lib.types) attrsOf oneOf bool int lines str;
      inherit (lib.my) mkOpt mkOpt';
    in {
      enable = mkEnableOption "Gecko-based libre browser";
      privacy.enable = mkEnableOption "Privacy-focused Firefox fork";

      profileName = mkOpt str config.user.name;
      settings = mkOpt' (attrsOf (oneOf [bool int str])) {} ''
        Firefox preferences set in <filename>user.js</filename>
      '';
      extraConfig = mkOpt' lines "" ''
        Extra lines to add to <filename>user.js</filename>
      '';
      userChrome = mkOpt' lines "" "CSS Styles for Firefox's interface";
      userContent = mkOpt' lines "" "Global CSS Styles for websites";
    };
  };

  config = mkMerge [
    (mkIf (config.modules.desktop.type == "wayland") {
      environment.variables.MOZ_ENABLE_WAYLAND = "1";
    })

    (mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
          extraPolicies = {
            DisableTelemetry = true;
            # add policies here...

            /* ---- EXTENSIONS ---- */
            ExtensionSettings = {
              "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
              # uBlock Origin:
              "uBlock0@raymondhill.net" = {
                userSettings = rec {
                  uiTheme = "dark";
                  uiAccentCustom = true;
                  uiAccentCustom0 = "#8300ff";
            #      cloudStorageEnabled = mkForce false; # Security liability?
                  importedLists = [
                    "https://filters.adtidy.org/extension/ublock/filters/3.txt"
                    "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                  ];
                  #externalLists = lib.concatStringsSep "\n" importedLists;
                };
                selectedFilterLists = [
                  "CZE-0"
                  "adguard-generic"
                  "adguard-annoyance"
                  "adguard-social"
                  "adguard-spyware-url"
                  "easylist"
                ];
              };
            };     
            /* ---- PREFERENCES ---- */
            # Set preferences shared by all profiles.
            Preferences = { 
              "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
              "extensions.pocket.enabled" = lock-false;
              # TAB cycle URL's, not buttons..
              "browser.toolbars.keyboard_navigation" = false;
              # Disable annoying translation pop-up!
              "browser.translations.automaticallyPopup" = false;
              # Enables dark-themed flash before page-load:
              "ui.systemUsesDarkTheme" = 1;
              # Developer tools -> uses dark theme
              "devtools.theme" = "dark";
              # FIXME: IM-Wheel -> Manual scroll speed ctrl bcs == buggy...
              "mousewheel.min_line_scroll_amount" = 35;
              # Enables ETP = decent security -> firefox containers = redundent
             # "privacy.donottrackheader.enabled" = true;
             # "privacy.donottrackheader.value" = 1;
              "privacy.purge_trackers.enabled" = true;
              # Syncs Firefox toolbar settings across machines
              # WARNING: May not work across OS'es
              "services.sync.prefs.sync.browser.uiCustomization.state" = true;
              # Enables userContent.css and userChrome.css for our theme modules
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              # Stop creating ~/Downloads!
              #"browser.download.dir" = "${config.user.home}/downloads";
              "browser.download.dir" = "/home/pungkula/Downloads";
              # Disables built-in password manager -> use external PM!
              "signon.rememberSignons" = false;
              # Firefox, DO NOT CHECK if you are the default browser..
              "browser.shell.checkDefaultBrowser" = false;
              # Disables "New Tab Page" feature
              "browser.newtabpage.enabled" = false;
              # Disables Activity Stream
              "browser.newtabpage.activity-stream.enabled" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              # Disables new tab tile ads & preload
              "browser.newtabpage.enhanced" = false;
              "browser.newtabpage.introShown" = true;
              "browser.newtab.preload" = false;
              "browser.newtabpage.directory.ping" = "";
              "browser.newtabpage.directory.source" = "data:text/plain,{}";
              # Reduces search engine noise in the urlbar's completion window
              # PS: Shortcuts and suggestions still work
              "browser.urlbar.suggest.searches" = false;
              "browser.urlbar.shortcuts.bookmarks" = false;
              "browser.urlbar.shortcuts.history" = false;
              "browser.urlbar.shortcuts.tabs" = false;
              "browser.urlbar.showSearchSuggestionsFirst" = false;
              "browser.urlbar.speculativeConnect.enabled" = false;
              # Prevents search terms from being sent to ISP
              "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
              # Disables sponsored search results
              "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
              "browser.urlbar.suggest.quicksuggest.sponsored" = false;
              # Shows whole URL in address bar
              "browser.urlbar.trimURLs" = false;
              # Disables non-useful funcionality of certain features
              "browser.disableResetPrompt" = true;
              "browser.onboarding.enabled" = false;
              "browser.aboutConfig.showWarning" = false;
              "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
              "extensions.shield-recipe-client.enabled" = false;
              "reader.parse-on-load.enabled" = false;
              # Allow seperate search-engine usage in private mode!
              "browser.search.separatePrivateDefault.ui.enabled" = true;

              # Security-oriented defaults:
              "security.family_safety.mode" = 0;
              # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
              "security.pki.sha1_enforcement_level" = 1;
              # https://github.com/tlswg/tls13-spec/issues/1001
              "security.tls.enable_0rtt_data" = false;
              # Uses Mozilla geolocation service instead of Google if given permission
              "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
              "geo.provider.use_gpsd" = false;
              # https://support.mozilla.org/en-US/kb/extension-recommendations
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "extensions.htmlaboutaddons.discover.enabled" = false;
              "extensions.getAddons.showPane" = false; # Uses Google Analytics
              "browser.discovery.enabled" = false;
              # Reduces File IO / SSD abuse, 15 seconds -> 30 minutes
              "browser.sessionstore.interval" = 1800000;
              # Disables battery API
              "dom.battery.enabled" = false;
              # Disables "beacon" asynchronous HTTP transfers (used for analytics)
              "beacon.enabled" = false;
              # Disables pinging URIs specified in HTML <a> ping= attributes
              "browser.send_pings" = false;
             # Disables gamepad API to prevent USB device enumeration
              "dom.gamepad.enabled" = false;
              # Prevents guessing domain names on invalid entry in URL-bar
              "browser.fixup.alternate.enabled" = false;
              # Disables telemetry settings
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.coverage.opt-out" = true;
              "toolkit.coverage.opt-out" = true;
              "toolkit.coverage.endpoint.base" = "";
              "experiments.supported" = false;
              "experiments.enabled" = false;
              "experiments.manifest.uri" = "";
              "browser.ping-centre.telemetry" = false;
              # https://mozilla.github.io/normandy/
              "app.normandy.enabled" = false;
              "app.normandy.api_url" = "";
              "app.shield.optoutstudies.enabled" = false;
              # Disables health reports (basically more telemetry)
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.healthreport.service.enabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              # Disables crash reports
              "breakpad.reportURL" = "";
              "browser.tabs.crashReporting.sendReport" = false;
              # Prevents the submission of backlogged reports
              "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

              # Disable automatic Form autofill
              "browser.formfill.enable" = false;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.available" = "off";
              "extensions.formautofill.creditCards.available" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "extensions.formautofill.heuristics.enabled" = false;
            };
          };
        };

        /* ---- PROFILES ---- */
        # Switch profiles via about:profiles page.
        # For options that are available in Home-Manager see
        # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
        profiles ={
          profile_0 = {           # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
            id = 0;               # 0 is the default profile; see also option "isDefault"
            name = "profile_0";   # name as listed in about:profiles
            isDefault = true;     # can be omitted; true if profile ID is 0
            settings = {          # specify profile-specific preferences here; check about:config for options
              "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
              "browser.startup.homepage" = "https://nixos.org";
              "browser.newtabpage.pinned" = [{
                title = "NixOS";
                url = "https://nixos.org";
              }];
              # add preferences for profile_0 here...
            };
          };
          profile_1 = {
            id = 1;
            name = "profile_1";
            isDefault = false;
            settings = {
              "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
              "browser.startup.homepage" = "https://ecosia.org";
              # add preferences for profile_1 here...
            };
          };
        # add profiles here...
        };
      };
    };
  };  
}


