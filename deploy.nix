{
  self,
  deploy-rs,
  ...
}: let
  deployConfig = name: system: cfg: {
    hostname = "${name}.zinn.tech";
    sshOpts = cfg.sshOpts or ["-A"];

    profiles = {
      system = {
        inherit (cfg) sshUser;
        path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
        user = "root";
      };
    };

    remoteBuild = cfg.remoteBuild or false;
    autoRollback = cfg.autoRollback or false;
    magicRollback = cfg.magicRollback or true;
  };
in {
  deploy.nodes = {
    hera = deployConfig "hera" "x86_64-linux" {
      sshUser = "scotte";
      remoteBuild = true;
    };
    ragnar = deployConfig "ragnar" "x86_64-linux" {
      sshUser = "scotte";
      remoteBuild = true;
    };
    titan = deployConfig "titan" "x86_64-linux" {
      sshUser = "scotte";
      remoteBuild = true;
    };
  };
  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
