{ config,... }: {
  config.home.file.".local/bin/dosync".source = ./dosync;
}
