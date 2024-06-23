{ pkgs, lib, config, ... }: {
  services.nomad = {
    enable = false;
    package = pkgs.nomad;
    enableDocker = false;
    dropPrivileges = false;
    settings = {
      datacenter = "datacenter-1";
      server = {
        enabled = true;
        bootstrap_expect = 3;
      };
      ports = {
        http = 4646;
        rpc = 4647;
        serf = 4648;
      };
    };
  };
}

