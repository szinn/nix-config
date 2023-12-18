{ config, lib, pkgs, ... }:
let
  ignorePatterns = ''
    !.env*
    !.github/
    !.gitignore
    !*.tfvars
    .terraform/
    .target/
    /Library/'';
in
{
  imports = [
    ./_1password
    ./alacritty
    ./colima
    ./devonthink
    ./devops
    ./dosync
    ./fish
    ./git
    ./gnupg
    ./go
    ./postgres
    ./rust
    ./sops
    ./ssh
    ./tmux
    ./vscode
    ./wezterm
  ];

  home.packages = with pkgs; [
    age
    bat
    dig
    du-dust
    duf
    eza
    fd
    fzf
    gh
    go-task
    jq
    pre-commit
    protobuf
    qrencode
    redis
    restic
    ripgrep
    shellcheck
    sops
    unixtools.watch
    wget
    yq-go
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    lazygit = {
      enable = true;
      settings = {
        gui.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --syntax-theme base16-256 --diff-so-fancy";
        };
      };
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        workspaces = "true";
        ctrl_n_shortcuts = "true";
      };
    };
    ripgrep = {
      enable = true;
      arguments = [ "--glob=!vendor" "--hidden" "--line-number" "--no-heading" "--sort=path" ];
    };
    neovim = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };

  home.file = {
    ".rgignore".text = ignorePatterns;
    ".fdignore".text = ignorePatterns;
    ".digrc".text = "+noall +answer"; # Cleaner dig commands
  };

  # Environment configuration
  home.sessionVariables = {
    FZF_DEFAULT_COMMAND = "fd -H -E '.git'";
  };
}