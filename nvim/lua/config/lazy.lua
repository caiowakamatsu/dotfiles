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

require("notify").setup({
	background_colour = "#000000",
})

local dap = require('dap')
dap.adapters.codelldb = {
  type = "executable",
  command = "/Users/caiowakamatsu/install/codelldb/extension/adapter/codelldb",
}

local dap = require('dap')
vim.api.nvim_create_user_command('Debug', function(opts)
  local args = vim.split(opts.args, " ")

  if #args < 1 then
    print("Usage: :Debug <executable> [<working_dir>] [<args>...]")
    return
  end

  local executable = args[1]
  local working_dir = (#args >= 2 and args[2] ~= "") and args[2] or vim.fn.getcwd()
  local program_args = {}
  if #args > 2 then
    for i = 3, #args do
      table.insert(program_args, args[i])
    end
  end

  dap.run({
    type = 'codelldb',
    request = 'launch',
    name = 'Custom Debug',
    program = executable,
    cwd = working_dir,
    args = program_args,
    stopOnEntry = false,
  })
end, {
  nargs = '+',
  complete = 'file',
  desc = 'Launch a debugger session with custom executable and args',
})

require("dapui").setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.8 },
        { id = "watches", size = 0.2 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "rounded",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

