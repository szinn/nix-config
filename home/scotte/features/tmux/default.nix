{ config, pkgs, lib, ... }:
let
  cfg = config.features.tmux;

  t-smart-manager = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "t-smart-tmux-session-manager";
      version = "v2.6.0";
      rtpFilePath = "t-smart-tmux-session-manager.tmux";
      # nix-shell -p nurl --command nurl https://github.com/joshmedeski/t-smart-tmux-session-manager v2.6.0
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "t-smart-tmux-session-manager";
        rev = "v2.6.0";
        hash = "sha256-B+NPeR0BZMX4wFtNK3M7shF2T5arXdIrFcVDRvplUT8=";
      };
    };
  t-nerd-font = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "t-nerd-font-window-name";
      version = "v2.1.0";
      rtpFilePath = "t-nerd-font-window-name.tmux";
      # nix-shell -p nurl --command nurl https://github.com/joshmedeski/tmux-nerd-font-window-name v2.1.0
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "tmux-nerd-font-window-name";
        rev = "v2.1.0";
        hash = "sha256-HqSaOcnb4oC0AtS0aags2A5slsPiikccUSuZ1sVuago=";
      };
    };
in
{
  options.features.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf (cfg.enable) {
    programs.tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
      terminal = "xterm-256color";
      historyLimit = 100000;
      plugins = with pkgs; [
        t-smart-manager
        t-nerd-font
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.fzf-tmux-url
      ];
      extraConfig = builtins.readFile ./tmux.conf;
    };

    home.packages = with pkgs; [
      gitmux
    ];
    xdg.configFile."tmux/gitmux.conf".source = ./gitmux.conf;
  };
}
