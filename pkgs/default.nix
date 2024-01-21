{ default, ... }: {
  perSystem =
    { pkgs
    , inputs'
    , ...
    }: {
      packages = {
        talosctl = pkgs.callPackage ./talosctl.nix { };
        tesla-auth = pkgs.callPackage ./tesla-auth.nix { };
      };
    };
}
