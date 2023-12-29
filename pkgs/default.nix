{ default, ... }: {
  perSystem =
    { pkgs
    , inputs'
    , ...
    }: {
      packages = {
        tesla-auth = pkgs.callPackage ./tesla-auth.nix { };
      };
    };
}
