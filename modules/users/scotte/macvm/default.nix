{ pkgs, config, ... }:
{
  system.activationScripts.postActivation.text = ''
    # Must match what is in /etc/shells
    sudo chsh -s /run/current-system/sw/bin/fish scotte
  '';

  modules.scotte = {
    editor = {
      vscode = {
        enable = true;
      };
    };

    shell = {
      alacritty.enable = true;
      tmux.enable = true;
    };
  };
}
