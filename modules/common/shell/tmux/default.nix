{ config, pkgs, lib, ... }: 
let
  t-smart-manager = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "t-smart-tmux-session-manager";
      version = "unstable-2023-06-05";
      rtpFilePath = "t-smart-tmux-session-manager.tmux";
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "t-smart-tmux-session-manager";
        rev = "0a4c77c5c3858814621597a8d3997948b3cdd35d";
        sha256 = "1dr5w02a0y84q2iw4jp1psxvkyj4g6pr87gc22syw1jd4ibkn925";
      };
    };
  t-nerd-font = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "t-nerd-font-window-name";
      version = "v2.1.0";
      rtpFilePath = "t-nerd-font-window-name.tmux";
      src = pkgs.fetchFromGitHub {
        owner = "joshmedeski";
        repo = "tmux-nerd-font-window-name";
        rev = "410d5becb3a5c118d5fabf89e1633d137906caf1";
        sha256 = "1dr5w02a0y84q2iw4jp1psxvkyj4g6pr87gc22syw1jd4ibkn925";
      };
    };
in {
  config = {
    home-manager.users.${config.user} = {
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
      # xdg.configFile."tmux/tmux.conf".text = builtins.readFile ./tmux.conf;
      xdg.configFile."tmux/gitmux.conf".text = builtins.readFile ./gitmux.conf;
    };
  };
}
