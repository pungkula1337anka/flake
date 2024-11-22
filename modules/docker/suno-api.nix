# EMPTY NIX OS MODULE
# import into flake.
{ config, pkgs, ... }:

{
  # example 
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };
}
