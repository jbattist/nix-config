{
  description = "Joe's NixOS Configuration (Niri + Plasma 6)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wayland compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wallpaper / theming palette generator
    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop shell (provides HM + NixOS modules)
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = inputs@{ self, nixpkgs, home-manager, niri, matugen, noctalia, ... }:
    let
      system = "x86_64-linux";
      username = "joe";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Helper: build a NixOS host using `hosts/<hostname>/default.nix`
      mkHost = hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs username hostname;
          };

          modules = [
            ./hosts/${hostname}/default.nix

            noctalia.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs username hostname; };
                backupFileExtension = "hm-backup";
                users.${username} = import ./modules/home/default.nix;
              };
            }
          ];
        };
    in
    {
      # Add new machines by adding another line here:
      #   crucible-dev = mkHost "crucible-dev";
      nixosConfigurations = {
        crucible-dev = mkHost "crucible-dev";
        nixos = mkHost "nixos";
      };

      # Optional: allow `home-manager switch --flake .#joe` (useful for non-NixOS too)
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username; hostname = "nixos"; };
        modules = [ ./modules/home/default.nix ];
      };
    };
}
