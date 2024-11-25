{ config, pkgs, user, home-manager, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  # Import keybindings
  imports = [
    #(import home-manager)
    ./nixos/dconf.nix
    ./programs/myfox.nix 
 #   ./programs/yubikey-touch.nix
  #  ./../../programs/mywolf.nix 
  ];

  # Enable the direnv integration for your shell (bash or zsh)
  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      clean = "sudo nix-collect-garbage -d";
      cleanold = "sudo nix-collect-garbage --delete-old";
      cleanboot = "sudo /run/current-system/bin/switch-to-configuration boot";
      nvim = "kitty @ set-spacing padding=0 && /etc/profiles/per-user/nomad/bin/nvim";
    };
    initExtra = "unsetopt beep";
    enableAutosuggestions = true;
  };
  # Enable Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  # Allow "unfree" licensed packages
  nixpkgs.config = { allowUnfree = true; };
  # Home Manager configuration
  programs.home-manager.enable = true;
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "23.05";
  # GTK customization
  gtk = {
    enable = true;
    font.name = "TeX Gyre Adventor 10";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Bibata-Modern-Classic
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Bibata-Modern-Classic
      '';
    };
  };
  # Home packages
  home.packages = with pkgs; [
    chromium
    neovim
    librewolf
    libsForQt5.qt5.qtwayland
    jellyfin-ffmpeg
    drawing
    vcard
    vlc
    amberol
    cava
    nordic
    papirus-icon-theme
    poweralertd
    dbus
    #gnome-browser-connector
    cudatoolkit
    gnomeExtensions.gsconnect
    vesktop
    keepass
  ];
  #Session variables
     home.sessionVariables = {
         BROWSER = "firefox";
         EDITOR = "nano";
         TERMINAL = "gnome-terminal";
         #NIXOS_OZONE_WL = "1";
         QT_QPA_PLATFORMTHEME = "gtk3";
         QT_SCALE_FACTOR = "1";
         #MOZ_ENABLE_WAYLAND = "1";
         #SDL_VIDEODRIVER = "wayland";
         #_JAVA_AWT_WM_NONREPARENTING = "1";
         #QT_QPA_PLATFORM = "wayland-egl";
         QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
         QT_AUTO_SCREEN_SCALE_FACTOR = "1";
         #WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
         #WLR_NO_HARDWARE_CURSORS = "1"; # if no cursor,uncomment this line  
         #GBM_BACKEND = "nvidia-drm";
         #CLUTTER_BACKEND = "wayland";
         # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
         # LIBVA_DRIVER_NAME = "nvidia";
         #WLR_RENDERER = "vulkan";
         #__NV_PRIME_RENDER_OFFLOAD="1"; 
         #XDG_CURRENT_DESKTOP = "gnome";
         #XDG_SESSION_DESKTOP = "gnome";
         #XDG_SESSION_TYPE = "wayland";
         #GTK_USE_PORTAL = "1";
         #NIXOS_XDG_OPEN_USE_PORTAL = "1";
         XDG_CACHE_HOME = "\${HOME}/.cache";
         XDG_CONFIG_HOME = "\${HOME}/flake/home/.config";
         XDG_BIN_HOME = "\${HOME}/flake/home/bin";
         #XDG_DATA_HOME = "\${HOME}/.local/share";
    };
    

}

