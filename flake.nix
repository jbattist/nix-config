{
  description = "Joe's NixOS Configuration - SDDM + Niri + KDE Plasma";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:jbattist/dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, matugen, dotfiles, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit inputs dotfiles;
        username = "joe";
        hostname = "nixos";
      };
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./configuration.nix
            /etc/nixos/hardware-configuration.nix  # Load from system path
            ./desktop.nix
            ./gaming.nix
            niri.nixosModules.niri
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.joe = import ./home.nix;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "joe" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
