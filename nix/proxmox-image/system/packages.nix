{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [ neovim wget ];
}
