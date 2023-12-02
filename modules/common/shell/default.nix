{ pkgs, ... }: {
    imports = [
      ./alacritty
      ./fish
      ./git.nix
      ./nixpkgs.nix
      ./tmux
      ./utilities.nix
    ];

    programs.bash.enable = true;
    programs.zsh.enable = true;
    programs.fish.enable = true;
    environment.shells = with pkgs; [ fish ];
}
