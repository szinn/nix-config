{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.filesystems.samba;
in {
  options.modules.filesystems.samba = {
    enable = mkEnableOption "samba";
  };

  config = mkIf cfg.enable {
    users.groups.samba-users = {};

    # services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
    services.samba = {
      enable = true;
      package = pkgs.samba;
      openFirewall = true;

      settings = {
        "homes" = {
          "browseable" = "no";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0664";
          "directory mask" = "0775";
        };

        # securityType = "user";

        "global" = {
          "min protocol" = "SMB2";
          "workgroup" = "WORKGROUP";

          "ea support" = "yes";
          "vfs objects" = "acl_xattr catia fruit streams_xattr";
          "fruit:metadata" = "stream";
          "fruit:model" = "MacSamba";
          "fruit:veto_appledouble" = "no";
          "fruit:posix_rename" = "yes";
          "fruit:zero_file_id" = "yes";
          "fruit:wipe_intentionally_left_blank_rfork" = "yes";
          "fruit:delete_empty_adfiles" = "yes";
          "fruit:nfs_aces" = "no";

          "browseable" = "yes";
          "guest ok" = "no";
          "guest account" = "nobody";
          "map to guest" = "bad user";
          "inherit acls" = "yes";
          "map acl inherit" = "yes";
          "valid users" = "@samba-users";

          "veto files" = "/._*/.DS_Store/";
          "delete veto files" = "yes";
        };
      };
    };
  };
}
