{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;

    # Core configuration options
    config = {
      name = "homie";
      latitude = 0;
      longitude = 0;
      elevation = 0;
      unit_system = "metric";
      time_zone = "UTC";
      temperature_unit = "C";
      country = "US";
      media_dirs = [];
      allowlist_external_dirs = [];
      allowlist_external_urls = [];
      media_url = "http://localhost:8123/local";
      auth_mfa_modules = [ "totp" ];
      auth_mfa_enabled = false;
    };

    # Frontend options
    frontend = {
      themes = "!include_dir_merge_named themes";
      ip_ban_enabled = true;
      ip_ban_interval = "1m";
      allowlist_external_dirs = [ "/mnt/data" ];
      allowlist_external_urls = [ ];
    };

    # HTTP configuration
    http = {
      server_host = "192.168.1.181";
      server_port = 8123;
      ssl_certificate = null;
      ssl_key = null;
      use_x_forwarded_for = true;
      trusted_proxies = [
        192.168.1.28
        172.26.0.2
      ];
    };

    # Custom components
    customComponents = [];
    customLovelaceModules = [];

    # Integration configurations
    defaultIntegrations = [
      "automation"
      "frontend"
      "hardware"
      "logger"
      "network"
      "system_health"
      "automation"
      "person"
      "scene"
      "script"
      "tag"
      "zone"
      "counter"
      "input_boolean"
      "input_button"
      "input_datetime"
      "input_number"
      "input_select"
      "input_text"
      "schedule"
      "timer"
      "backup"
    ];

    # Extra Python packages
    extraPackages = pkgs.python3Packages: with pkgs.python3Packages; [
      # postgresql support
      psycopg2
    ];

    # Lovelace configuration (UI cards)
    lovelaceConfig = {
      title = "Home Assistant";
      views = [ {
        title = "Overview";
        cards = [ {
          type = "markdown";
          title = "Welcome!";
          content = "Hello!";
        } ];
      } ];
    };

    # Custom user-defined components
    customComponents = with pkgs.home-assistant-custom-components; [
      prometheus_sensor
    ];

    # Enable optional custom modules (example)
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      mini-graph-card
      mini-media-player
    ];
  };
}

