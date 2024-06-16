# Global configuration for Nix itself.
{ config, pkgs, inputs, ... }:

{
  users.users = {
    eugene = {
      uid = 1000;
      isNormalUser = true;
      # TODO: systemd-journal is some kind of bug: I shouldn't need to be in it (see man journalctl)
      extraGroups = [ "wheel" "podman" "systemd-journal" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0x3Ae+qrGH3WQpu1uKCcn0Nc9jCDFyMMmKrnan4JLz nguyendinhnhattai.work@gmail.com"
      ];
    };
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0x3Ae+qrGH3WQpu1uKCcn0Nc9jCDFyMMmKrnan4JLz nguyendinhnhattai.work@gmail.com"
    ];
  };

  boot.initrd.network.ssh.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII0x3Ae+qrGH3WQpu1uKCcn0Nc9jCDFyMMmKrnan4JLz nguyendinhnhattai.work@gmail.com"
  ];

  security.sudo.wheelNeedsPassword = false;

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
  system.stateVersion = "24.05";
}
