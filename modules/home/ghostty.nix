{...}: {
  xdg.configFile."ghostty/config".text = ''
    theme = dark:Catppuccin Mocha,light:Builtin Solarized Light
    font-family = Hack Nerd Font
    font-size = 11
    font-thicken = true
    cursor-style = block
    cursor-style-blink = false
    copy-on-select = false
    scrollback-limit = 100000
    macos-option-as-alt = true
    mouse-hide-while-typing = true
  '';
}
