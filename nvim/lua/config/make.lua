local M = {}

local float_term = require("util.float").float_terminal

vim.api.nvim_create_user_command("Make", function(opts)
  if opts.args == "" then
    print("Usage: :Make <targets>")
    return
  end
  local args = vim.split(opts.args, "%s+")
  float_term(
    vim.list_extend({ "make" }, args),
    { height_ratio = 0.8, width_ratio = 0.8, border = "single" }
  )
end, { nargs = "*" })

