{ inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  security.pam.enableSudoTouchIdAuth = true;
}
