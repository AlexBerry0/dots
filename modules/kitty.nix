{
  pkgs,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
      size = 11;
    };
    settings = {
      cursor_blink_interval = "0";
      scrollback_lines = "100000";
      scrollback_pager_history_size = "256";
      copy_on_select = "no";
      open_url_with = "xdg-open";
      enable_audio_bell = "no";
      linux_display_server = "x11";
    };
  };
}
