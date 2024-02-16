{ pkgs, config, ... }:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules.scotte = {
    devops = {
      enable = true;
    };
  };

  users.users.scotte = {
    uid = 1000;
    group = "scotte";
    hashedPasswordFile = config.sops.secrets.scotte-password.path;

    isNormalUser = true;
    extraGroups = [ "wheel" ] ++ ifGroupsExist [
      "network"
      "samba-users"
    ];
  };

  users.groups.scotte = {
    gid = 1000;
  };

  sops.secrets.scotte-password = {
    sopsFile = ./secrets.sops.yaml;
    neededForUsers = true;
  };

  home-manager.users.scotte.programs.fish.functions = {
    zstat = {
      description = "Statistics on atlas zpool";
      body = builtins.readFile ./functions/zstat.fish;
    };
  };

  modules.scotte = {
    editor = {
      neovim.enable = true;
      vscode.server-enable = true;
    };
  };
}
