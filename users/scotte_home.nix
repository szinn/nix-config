{ inputs, config, ... }: {
  time.timeZone = "America/Toronto";
  user = "scotte";
  fullName = "Scotte Zinn";
  gitName = "Scotte Zinn";
  gitEmail = "scotte@zinn.ca";

  modules.sops = {
    enable = true;
    defaultSopsFile = ./secrets.sops.yaml;
    secrets = {
      abc = {
        path = "${config.home-manager.users.${config.user}.xdg.configHome}/abc";
      };
    };
  };
  modules.devops.enable = true;
  modules.gnupg.enable = true;
}
