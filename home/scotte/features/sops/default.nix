{ ageFile, sopsFile, secrets }: { lib, pkgs, config, inputs, ... }: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  config.home.packages = with pkgs; [
    sops
    age
  ];

  config.sops = {
    defaultSopsFile = sopsFile;
    age.keyFile = ageFile;
    secrets = secrets;
  };

  config.home.sessionVariables = {
    SOPS_AGE_KEY_FILE = ageFile;
  };
}
