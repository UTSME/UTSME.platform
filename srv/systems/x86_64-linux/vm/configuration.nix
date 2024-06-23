{ pkgs, modulesPath, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  config = { environment.systemPackages = with pkgs; [ neovim git ]; };
}

