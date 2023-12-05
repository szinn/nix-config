{ pkgs, inputs, config, lib, ... }:
let
  default-vscode-settings = builtins.fromJSON (builtins.readFile ./vscode_settings.json);
  authorized_keys = "${config.homePath}/.ssh/authorized_keys";
in {
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
  modules.vscode = {
    enable = true;
    package = pkgs.vscode;
    config = default-vscode-settings;
    extensions = (with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
    ]);
  };

  home-manager.users.${config.user} = { lib, ... }: {
    home.file = {
      ".ssh/allowed_signers".text = ''
        scotte@zinn.ca ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7T92EOEawunpuGClUPZtjl6gLjqz+X2xvLuvmk0UFn
        scotte@zinn.ca ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP1JMwwIE7/qpqLNOvIcYNy6CHhfR8S/Tm0ZCBFchcsPuvtQ2yuqjmi6DGaDiUzV2ln8tFzBVhi+eOor9r5l/XwK0wcNpuBbdNf0/C0z6SklEKZctU5sCFvEIw4V4WfNctChrarPCfZo7lae/7PJKtYQDuqwC0KWY2I43+kPPkR0o+sRYcMdvYgBHcNfUQNcXoO0nWlMcaEocmcFBq82E7RI8uY5RR6liF/VvpIj5C9FviTd7IIFdhVy+w6p7QJr/kUQAQCYF2sVrAH+ZqVVUh18LhaA0SM4mqnJyaCqKfdl8orufRaI61uxS70RlnJH0WYALejOqtx7IBMJGOdTM0ZlCYYpfqqUrRvbYQdiMlfXSCoMk8r3ldSY+FLw3FBMnOzUK35Srio1g6xoYsRChQbLZiJKDBRcGNghmiLuT3EsGF37+hjOOtKWLXXSnPZQKQckc5O1spSW4oR8Ij4JXfDyKL0n5H+MPn8oThK+jePTmCPLKMUo9OpFAtz/maZ8z8mAkHpdVt7mjL3D1sEGkIbo6XDjICfFEjLbnVJhKWAXluuAkzL9Bp52lkop8V4ALk5oTVe/c52oJQhiD6XVjwjJJ0DrvGScLhDzZARpd1d2eaGE4fbow8NgkkW5lpaXNvW0bN6L/+7N4nHLPWD9WKRU6Lee2FXk0C5Gnn1QB0zQ==
        scotte@zinn.ca ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2VWgq5MEINPHdTEx9jhDxXB80ZjWOXB9M0X0XtoHih
      '';
      ".ssh/authorized_keys".text = ''
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDP1JMwwIE7/qpqLNOvIcYNy6CHhfR8S/Tm0ZCBFchcsPuvtQ2yuqjmi6DGaDiUzV2ln8tFzBVhi+eOor9r5l/XwK0wcNpuBbdNf0/C0z6SklEKZctU5sCFvEIw4V4WfNctChrarPCfZo7lae/7PJKtYQDuqwC0KWY2I43+kPPkR0o+sRYcMdvYgBHcNfUQNcXoO0nWlMcaEocmcFBq82E7RI8uY5RR6liF/VvpIj5C9FviTd7IIFdhVy+w6p7QJr/kUQAQCYF2sVrAH+ZqVVUh18LhaA0SM4mqnJyaCqKfdl8orufRaI61uxS70RlnJH0WYALejOqtx7IBMJGOdTM0ZlCYYpfqqUrRvbYQdiMlfXSCoMk8r3ldSY+FLw3FBMnOzUK35Srio1g6xoYsRChQbLZiJKDBRcGNghmiLuT3EsGF37+hjOOtKWLXXSnPZQKQckc5O1spSW4oR8Ij4JXfDyKL0n5H+MPn8oThK+jePTmCPLKMUo9OpFAtz/maZ8z8mAkHpdVt7mjL3D1sEGkIbo6XDjICfFEjLbnVJhKWAXluuAkzL9Bp52lkop8V4ALk5oTVe/c52oJQhiD6XVjwjJJ0DrvGScLhDzZARpd1d2eaGE4fbow8NgkkW5lpaXNvW0bN6L/+7N4nHLPWD9WKRU6Lee2FXk0C5Gnn1QB0zQ== scotte@zinn.ca
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN7T92EOEawunpuGClUPZtjl6gLjqz+X2xvLuvmk0UFn scotte@zinn.ca
      '';
    };

    home.activation = {
      removeExistingAuthorizedKeys = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm -rf "${authorized_keys}"
      '';

      overwriteAuthorizedKeysSymlink = let
        source_keys = config.home-manager.users.${config.user}.home.file.".ssh/authorized_keys".source;
      in lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        rm -rf "${authorized_keys}"
        cp "${source_keys}" "${authorized_keys}"
      '';
    };
  };
}
