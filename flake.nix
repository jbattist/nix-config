{
  description = "jbattist NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = { url = "github:jbattist/dotfiles"; flake = false; };

  };

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations."crucible-dev" = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit dotfiles; };
        modules = [
          ./hosts/crucible-dev/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit dotfiles; };
            home-manager.users.joe = import ./modules/home/base.nix;
          }
        ];
      };
    };
}
