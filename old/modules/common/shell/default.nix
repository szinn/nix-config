{ pkgs, ... }: {
    imports = [
      ./alacritty
      ./devops
      ./fish
      ./git.nix
      ./gnupg
      ./nixpkgs.nix
      ./ssh
      ./tmux
      ./utilities.nix
    ];

    programs.bash.enable = true;
    programs.zsh.enable = true;
    programs.fish.enable = true;
    environment.shells = with pkgs; [ fish ];
}
