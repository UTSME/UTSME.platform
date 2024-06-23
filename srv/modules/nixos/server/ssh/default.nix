{ lib, config, ... }: {

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin =
        lib.mkForce "prohibit-password"; # enable root login for remote deploy
    };
    extraConfig = ''
      # Automatically remove stale sockets on connect
      StreamLocalBindUnlink yes

      # Send timeout message every 60 s to request answer from clients
      ClientAliveInterval 60
    '';
  };
}
