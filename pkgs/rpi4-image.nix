# nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./rpi4-image.nix
{ ... }:
{
  nixpkgs.localSystem.system = "aarch64-linux";
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi4.nix>
    ./base-config.nix
  ];

  # maurice
  users.users.root.openssh.authorizedKeys.keys = [
    KEYS 
  ];
}
