# Global configuration for Nix itself.
{ config, pkgs, inputs, ... }: {
  users = {
    mutableUsers = false;
    users = {
      deploy = {
        uid = 1000;
        isNormalUser = true;
        home = "/home/deploy";
        shell = pkgs.bash;
        extraGroups = [ "wheel" "systemd-journal" "networkmanager" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoRjB5AqGrenuJz8jcW9qeIHgV2uJ8TySp/vpzyLab5 nguyendinhnhattai.work@gmail.com"
        ];
      };
      root = {
        inherit (config.users.users."deploy") initialHashedPassword;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOoRjB5AqGrenuJz8jcW9qeIHgV2uJ8TySp/vpzyLab5 nguyendinhnhattai.work@gmail.com"
        ];
      };
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [{
    users = [ "deploy" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

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
