{...}: {
  xdg.configFile."ghostty/config".text = ''
    theme = dark:Catppuccin Mocha,light:Catppuccin Latte
    font-family = Hack Nerd Font
    font-size = 11
    cursor-style = block
    cursor-style-blink = false
    copy-on-select = false
    scrollback-limit = 100000
    macos-option-as-alt = true
    window-theme = system
    macos-titlebar-style = transparent
    mouse-hide-while-typing = true
  '';
}
