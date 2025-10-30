local M = {}

local float_term = require("util.float").float_terminal

vim.api.nvim_create_user_command("Make", function(opts)
  local t = opts.args
  if t == "" then print("Usage: :Make <target>"); return end
  float_term(
		{ "make", t},
    { height_ratio = 0.8, width_ratio = 0.8, border = "single" }
  )
end, { nargs = 1 })

return M

