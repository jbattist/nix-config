{
  description = "jbattist NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    dotfiles = { url = "github:jbattist/dotfiles"; flake = false; };

  };

    outputs = inputs@{ self, nixpkgs, home-manager, dotfiles, ... }:

    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations."crucible" = lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs dotfiles; };
        
        modules = [
          ./hosts/crucible/default.nix
          ./noctalia.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs dotfiles; };
            home-manager.users.joe = import ./modules/home/base.nix;
          }
        ];
      };
    };
}
