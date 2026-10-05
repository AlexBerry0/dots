vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.winborder = "rounded"
vim.o.spell = true
vim.o.spelllang = "en_gb"
vim.g.mapleader = " "

require("oil").setup()
require("nvim-surround").setup()
require("ultimate-autopair").setup()
