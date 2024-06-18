{ pkgs, modulesPath, lib, ... }:

{
  imports = [
    ./../../modules/nixos/server/ssh
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  #systemd.services."getty@tty1" = {
  #  enable = lib.mkForce true;
  #  wantedBy = [ "getty.target" ]; # to start at boot
  #  serviceConfig.Restart = "always"; # restart when session is closed
  #};

  environment.systemPackages = with pkgs; [ neovim binutils ];
}

