{ username }: { pkgs, ... }:
{
  imports = [
    (import ./neovim { username = username; })
    (import ./vscode { username = username; })
  ];
}
