local function make_transparent()
  local groups = {
    "Normal","NormalNC","NormalFloat","FloatBorder",
    "SignColumn","EndOfBuffer","LineNr","CursorLineNr",
    "StatusLine","MsgArea","WinSeparator",
    -- common plugin groups:
    "TelescopeNormal","TelescopeBorder",
    "NvimTreeNormal","NvimTreeNormalNC",
    "NeoTreeNormal","NeoTreeNormalNC",
  }
  for _, g in ipairs(groups) do
    pcall(vim.api.nvim_set_hl, 0, g, { bg = "NONE" })
  end
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = make_transparent,
  desc = "Force transparent background after any colorscheme loads",
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config.opts")

require("lazy").setup({
  spec = {
    { import = "plugins.coding" },
    { import = "plugins.colors" },
    { import = "plugins.ui" },
		{ import = "plugins.debugging" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

require("config.cmake")
require("config.lsp")
require("config.dap")

require("notify").setup({
	background_colour = "#000000",
})

