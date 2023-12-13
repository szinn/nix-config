{ config,... }: {
  config.home.file.".local/bin/dosync".source = ./dosync;
  config.home.file.".local/bin/restore".source = ./restore;
}
