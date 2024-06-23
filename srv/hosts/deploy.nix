{ self
, deploy
, ...
}:
let
  mkNode = server: ip: fast: {
    hostname = "${ip}:22";
    fastConnection = fast;
    profiles.system.path =
      deploy.lib.x86_64-linux.activate.nixos
        self.nixosConfigurations."${server}";
  };
in
{
  user = "root";
  sshUser = "root";
  nodes = {
    lion = mkNode "lion" "138.25.249.136" true;
  };
}
