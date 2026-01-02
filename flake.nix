{
  description = "Joe's NixOS Configuration - SDDM + Niri + Noctalia";

  inputs = {
    # Core nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri - scrollable tiling Wayland compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Matugen - material color generation
    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Your dotfiles repository
    dotfiles = {
      url = "github:jbattist/dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, matugen, dotfiles, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Allow unfree packages
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Common special args passed to all modules
      specialArgs = {
        inherit inputs dotfiles;
        username = "joe";
        hostname = "nixos";
      };
    in
    {
      # NixOS system configurations
      nixosConfigurations = {
        # Default/main desktop configuration
        default = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            # Core system configuration
            ./hosts/default/configuration.nix
            ./hosts/default/hardware-configuration.nix
            
            # Niri flake module
            niri.nixosModules.niri
            
            # Home Manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.joe = import ./home/home.nix;
              };
            }
          ];
        };
      };

      # Standalone Home Manager configurations (for non-NixOS systems)
      homeConfigurations = {
        "joe" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [ ./home/home.nix ];
        };
      };
    };
}
