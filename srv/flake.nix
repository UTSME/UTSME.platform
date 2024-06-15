{
  description = "NixOs servers system flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; # nix packages (default)

    #nixpkgs-unstable.url =
    #  "github:nixos/nixpkgs/nixos-unstable"; # unstable nix packages

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # user environment manager
    #home-manager = {
    #  url = "github:nix-community/home-manager/release-24.05";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #snowfall-lib.url = "github:snowfallorg/lib/dev";
    #snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    #microvm = {
    #  url = "github:astro/microvm.nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs,... }@inputs: {
    nixosConfigurations = {
      "nixos2" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Pass these stuff as inputs to the configuration files
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs;
        };
        modules = [
          ./systems/x86_64-linux/nomad/configuration.nix
          ./systems/core.nix

          ./modules/server/nomad
          ./modules/server/podman
        ];
      };
    };
  };
}
