_:

{
  imports = [
    ./hardware-configuration.nix

    ./system/nixos.nix
    ./system/users.nix
    ./system/services.nix
    ./system/packages.nix
  ];

  # set hostname
  networking.hostName = "nixos";
}
