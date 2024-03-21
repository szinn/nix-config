{pkgs ? import <nixpkgs> {}}: rec {
  tesla-auth = pkgs.callPackage ./tesla-auth.nix {};
  talosctl = pkgs.callPackage ./talosctl.nix {};
}
