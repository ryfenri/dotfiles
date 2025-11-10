{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

	caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };	

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    aagl = {
		url = "github:ezKEa/aagl-gtk-on-nix";
		inputs.nixpkgs.follows = "nixpkgs";
	};

    home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }@inputs:
    let
		system = "x86_64-linux";
    in {
		nixosConfigurations.ryo = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = {inherit inputs;};
			modules = [
				./nixos/configuration.nix
				inputs.aagl.nixosModules.default
			];
		};

		homeConfigurations.ryfenri = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.${system};
			
			extraSpecialArgs = { inherit inputs; };

			modules = [ 
				./home-manager/home.nix
			];
		};
    };
}
