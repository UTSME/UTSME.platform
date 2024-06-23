_:

{
  imports = [
    ./hardware-configuration.nix

    ./system/nixos.nix
    ./system/users.nix
    ./system/services.nix
    ./system/packages.nix
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # set hostname
  networking.hostName = "nixos";
}
