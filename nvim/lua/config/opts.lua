vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.autoindent = true

vim.g.equalalways = false

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })
vim.opt.shell = "/usr/bin/zsh"
