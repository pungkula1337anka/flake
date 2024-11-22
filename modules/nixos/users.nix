{ config, pkgs, lib, inputs, user, ... }:
{


  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user} = {
      isNormalUser = true;
      description = "${user}";
      extraGroups = [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" "docker" "amdgpu" ];
      packages = with pkgs; [
        xdg-utils
        xwaylandvideobridge
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa x7qq8zRAH5jdxUduQ/ThAmvjYm91H42QVm70OCFjjb8dg9LIb/va2j1eakNlBiwCmUK7frmRkWjFj+2t5zCTd2iLpygLv7PvFVIidxAoXLdTxilAAg2ZlX/xSGvRPkaqX/ZQfR5j3OCVYy6aV4VonbIUids7kUynRz9SRN2AHmLpK/oniwlwhAS5aa0PvC8Ln7x3wzhH501sLKk+krNpOEr4E1AA/VwOMqSqU4KTMoYzkUix9YnnAf70AQV6rZ4NxNrqWcZve/UGqMxtUbxMP7rL8hxKihc0Zdus5zxDEZ36oXIDYq9kQ3KgJZx4aVPePEX68A8fxhx6zIOfsg0Hz6M3ko53MhG/qZhYmDvTG1548tgn24gQjEawRjUc2a6gEH+va+TP99260ELeWZD3AHzIzL+ln4BBGcYgNglkIxpI5gH7LqeQ+XHlW8iQbnlfRUYKo72MGA8KLDPP3IHhWa5cSN4DKBlgEJ8ijUbcYqES4dK34cqyM1JWVTnEdw== pungkula@desktop.com"
      ];
    };


  # swaylock pass verify
    security.pam.services.swaylock = {
      text = ''
      auth include login
      '';
    };
  
    services.gnome.gnome-keyring.enable = true;
    programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
    services.gvfs.enable = true; 

  # gnome outside gnome
    programs.dconf.enable = lib.mkDefault true;

  # DIRS
    environment.etc."xdg/user-dirs.defaults".text= ''
    DESKTOP=$HOME/duckOS
    DOWNLOAD=$HOME/Downloads
    TEMPLATES=$HOME/Templates
    PUBLICSHARE=$HOME/Public
    DOCUMENTS=$HOME/duckOS/dev
    MUSIC=$HOME/Music
    PICTURES=$HOME/Photos
    VIDEOS=$HOME/Video 
    '';


    users.defaultUserShell = pkgs.bash;   
}

