{pkgs ? import <nixpkgs> {}}: rec {
  tesla-auth = pkgs.callPackage ./tesla-auth.nix {};
}
