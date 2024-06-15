# Global configuration for Nix itself.
{ config, pkgs, inputs, ... }:

{

  # My user in all hosts
  users.users.h = {
    uid = 1000;
    isNormalUser = true;
    # TODO: systemd-journal is some kind of bug: I shouldn't need to be in it (see man journalctl)
    extraGroups = [ "wheel" "podman" "systemd-journal" "networkmanager" ];
    openssh.authorizedKeys.keys = [''
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCUfT5gIqMkjblTRc+OEAncVa+b8Qe/S7a1TfZ8bEU2f04VHuvL077jXl
      AYhna73CoOW35RKiv6taEnLyoE58tA9NJMWDcetaZvEqGJH1LrX942O7jSfayFd1VCqUc/frUkJkh2mk6a6Lys+0fAmbFG
      cyJX1veELTzfn7dwSoaurW1ZXuNUkTzcMazHPVmrc2psngDVu00DfxFBjHvsUkjBBhzFz9skh9RC5w9rup6pg1uXlhCBtS
      MA3ME6VEIBHNhGgye8zGgHQdI2zgU++u4Sz/5JmCj9hTg7+xi6p4a8R2iz4OKpOJNrLpjNc06QIe8+diHu/f1SmJSX40yY
      dDdlufC0ucS4ZVc9T0KFyPLRj4IcUysWBYKvAWHY3r6OtdoxiZyUI2LDJ3WYaKGnx4X1YxfLRLHd5A0lbu3cx+k+MdrN/n
      kjPl1MDASUBwCibjDwXqXn7T6zkC2zSndmLqaMCcDnaBws7EqMEsEW+jaRXHSRBLpHHjR/WlzXO6E0yr8= moritzzmn@M
      oritzs-MBP.modem''];
  };

  nix = {
    settings = {
      # enable newer commands and flakes
      experimental-features = [ "nix-command" "flakes" ];

      # automatically removes older builds
      auto-optimise-store = true;

      # use all CPUs for building
      max-jobs = "auto";
      cores = 0; # 0 means all cores

      # Add extra caches
      substituters = [
        # https://cache.nixos.org is included by default
        # github:nix-community/*
        #"https://nix-community.cachix.org/"
      ];
      #trusted-public-keys = [
      #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #];

      # Allow my user to nix around
      trusted-users = [ "root" "h" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    # Use systems's Flakes for everything instead of downloading/updating.
    registry = { nixpkgs.flake = inputs.nixpkgs; };
  };

  nixpkgs.config.allowUnfree = true;
}
