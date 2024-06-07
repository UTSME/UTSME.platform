
{
  description = "NixOs servers system flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; # nix packages (default)

    nixpkgs-unstable.url =
      "github:nixos/nixpkgs/nixos-unstable"; # unstable nix packages

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # user environment manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib.url = "github:snowfallorg/lib/dev";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, snowfall-lib,  ... }@inputs:
    let
    in {
    };
}
