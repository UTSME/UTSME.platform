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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, deploy-rs, ... }@inputs: {
    nixosConfigurations = {
      "nixos2" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit (nixpkgs) lib;
          inherit inputs;
        };
        modules = [
          ./systems/x86_64-linux/nomad/server/configuration.nix
          ./systems/core.nix

          #./modules/server/nomad
          #./modules/server/podman
        ];
      };
    };

    deploy = {
      sshOpts = [ "-p" "22" ];
      sshUser = "root";
      user = "root";
      # Auto rollback on deployment failure, recommended off.
      #
      # NixOS deployment can be a bit flaky (especially on unstable)
      # and you may need to deploy twice to succeed, but auto rollback
      # works against that and make your deployments constantly fail.
      autoRollback = false;

      # Auto rollback on Internet disconnection, recommended off.
      #
      # Rollback when your new config killed the Internet connection,
      # so you don't have to use VNC or IPMI from your service provider.
      # But if you're adjusting firewall or IP settings, chances are
      # although the Internet is down atm, a simple reboot will make everything work.
      # Magic rollback works against that, so you should keep that off.
      magicRollback = false;
      nodes."nixos2" = {
        remoteBuild = true;
        hostname = "138.25.249.154";
        #fastConnection = true;
        #interactiveSudo = true;
        profiles = {
          system = {
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations."nixos2";
          };
        };
      };
    };

    #checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
