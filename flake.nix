{
  description = "A Flake with accessibility as default.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";   
    agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, sops-nix, hyprland, home-manager, ... }: 
    let
      user = "pungkula";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        # -> DESKTOP <- #
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit user;};
          modules = [ ./hosts/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit user;};
              home-manager.users.${user} = import ./modules/home/gnome/home.nix;
            }
            #agenix.nixosModules.age
            #agenix.nixosModules.default
            sops-nix.nixosModules.sops
            ./modules/services/ssh.nix                 
            ./modules/shell/bash.nix
           # ./modules/monero.nix
          ];
        };
        # -> PHONE <- #
        phone = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {inherit user;};
          modules = [ ./hosts/phone/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit user;};
              home-manager.users.${user} = import ./modules/home/gnome/home.nix;
            }
          ];
        };
        # -> LAPTOP <- #
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit user;};
          modules = [ ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {inherit user;};
              home-manager.users.${user} = import ./modules/home/gnome/home.nix;
            }
            sops-nix.nixosModules.sops
            ./modules/services/ssh.nix
            ./modules/shell/bash2.nix
          ];
        };
      };
    };
}





