{...}: {
  imports = [
    ./filesystems
    ./services
    ./users
  ];

  nix = {
    gc.dates = "weekly";
    settings.trusted-users = ["root" "@wheel"];
  };

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
