_: {
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        age
        git
        gnupg
        go-task
        jq
        nix
        pre-commit
        sops
        ssh-to-age
        statix
      ];
    };

    formatter = pkgs.alejandra;
  };
}
