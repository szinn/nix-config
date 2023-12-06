{ config, pkgs, lib, ... }: {
  config = {
    users.users.${config.user} = {
      name = "${config.user}";
      home = "${config.homePath}";
      shell = pkgs.fish;
    };

    system = {
      activationScripts.postActivation.text = ''
        # Must match what is in /etc/shells
        sudo chsh -s /run/current-system/sw/bin/fish ${config.user}
      '';
    };
  };
}
