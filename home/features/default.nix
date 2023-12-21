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
    ./colima
    ./devonthink
    ./devops
    ./dosync
    ./go
    ./postgres
    ./rust
    ./sops
    ./wezterm
  ];
}
