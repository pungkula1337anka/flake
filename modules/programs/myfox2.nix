# EMPTY NIX OS MODULE
# import into flake.
{ config, pkgs, ... }:

{
  # Include the module for Firefox configuration
  imports = [ ./firefox.nix ];

  # Configure Firefox
  modules.home.firefox = {
    enable = true;  # Enable the Firefox browser

    privacy.enable = false;  # Do not use the privacy-focused variant (LibreWolf)

    # Set profile name for Firefox
    profileName = "defaultProfile";

    # Firefox preferences to set
    settings = {
      "browser.startup.page" = 1;  # Open the homepage on startup
      "browser.startup.homepage" = "https://www.example.com";  # Set the homepage URL
      "browser.toolbars.keyboard_navigation" = false;  # Disable keyboard navigation
      "browser.translations.automaticallyPopup" = false;  # Disable translation pop-ups
      "browser.urlbar.suggest.searches" = false;  # Disable search suggestions
      "browser.download.dir" = "${config.home.homeDirectory}/downloads";  # Set download directory
    };

    # Extra configuration lines to add to user.js
    extraConfig = ''
      // Additional user.js settings
      user_pref("browser.privatebrowsing.autostart", true);
    '';

    # Custom CSS for Firefox's interface
    userChrome = ''
      /* Custom userChrome.css styles */
      #nav-bar {
        background-color: #333;
      }
    '';

    # Custom CSS for websites
    userContent = ''
      /* Custom userContent.css styles */
      body {
        background-color: #f0f0f0;
      }
    '';
  };

  # Configure environment and packages
  environment.systemPackages = [
    pkgs.firefox  # Ensure Firefox is installed
  ];

  # If privacy is enabled, configure LibreWolf
  environment.systemPackages = lib.mkIf config.modules.home.firefox.privacy.enable [
    pkgs.librewolf  # Install LibreWolf if privacy is enabled
  ];

  # Example of additional desktop settings for Firefox Nightly
  user.packages = [
    pkgs.firefox-nightly-bin
  ];

  # Optional: Create a desktop entry for Firefox Nightly with private mode
  environment.etc."xdg/autostart/firefox-nightly-private.desktop".text = ''
    [Desktop Entry]
    Name=Firefox Nightly (Private)
    GenericName=Launch a private Firefox Nightly instance
    Exec=${pkgs.firefox-nightly-bin}/bin/firefox-nightly --private-window
    Icon=firefox-nightly
    Type=Application
    Categories=Network;WebBrowser;
  '';
}
}
