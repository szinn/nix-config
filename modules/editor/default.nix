{ username }: { pkgs, ... }:
{
  imports = [
    ( import ./vscode { username = username; } )
  ];
}
