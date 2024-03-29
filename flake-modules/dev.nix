_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        age
        git
        gnupg
        jq
        nix
        sops
        ssh-to-age
        statix
      ];
    };

    formatter = pkgs.alejandra;
  };
}
