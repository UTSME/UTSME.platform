{ pkgs, modulesPath, lib, ... }:

{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostRevolveConf = false;
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
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    binutils
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    dockerSocket.enable = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    extraConfig = ''
      # Automatically remove stale sockets on connect
      StreamLocalBindUnlink yes

      # Send timeout message every 60 s to request answer from clients
      ClientAliveInterval 60
    '';
  };

  services.nomad = {
    enable = false;
    package = pkgs.nomad;
    enableDocker = false;
    extraSettingsPlugins = with pkgs; [ nomad-driver-podman ];
    dropPrivileges = false;
    extraPackages = with pkgs; [ podman ];
    # Nomad configuration, as Nix attribute set.
    settings = {
      datacenter = "datacenter-1";
      client.enabled = true;
      server = {
        enabled = true;
        bootstrap_expect = 1;
      };
      plugin = [{ nomad-driver-podman = { config = { enable = true; }; }; }];
      ports = {
        http = 4646;
        rpc = 4647;
        serf = 4648;
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

