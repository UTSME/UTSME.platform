{ pkgs, modulesPath, lib, ... }: {
  imports = [
    ./../../../../modules/server/nomad/server
    ./../../../../modules/server/podman
    ./../../../../modules/server/ssh
  ];
  config = {
    imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

    networking = {
      dhcpcd.enable = false;
      useDHCP = false;
      #useHostRevolveConf = false;
      firewall.allowedTCPPorts = [ 22 ];
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

    # Supress systemd units that don't work because of LXC
    systemd.suppressedSystemUnits = [
      "dev-mqueue.mount"
      "sys-kernel-debug.mount"
      "sys-fs-fuse-connections.mount"
    ];

    # start tty0 on serial console
    systemd.services."getty@tty1" = {
      enable = lib.mkForce true;
      wantedBy = [ "getty.target" ]; # to start at boot
      serviceConfig.Restart = "always"; # restart when session is closed
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      binutils
    ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = false;
      dockerSocket.enable = false;
      defaultNetwork.settings.dns_enabled = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
