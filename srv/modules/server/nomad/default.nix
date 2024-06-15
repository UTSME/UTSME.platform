{ pkgs, lib, config, ... }: {
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
}
