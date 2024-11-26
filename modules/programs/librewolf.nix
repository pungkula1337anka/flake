
{ config, pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    settings = { "browser.startup.homepage" = "https://example.com"; };
  };
}
