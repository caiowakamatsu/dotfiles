local dap = require('dap')

dap.adapters.codelldb = {
  type = "executable",
  command = "/Users/caiowakamatsu/install/codelldb/extension/adapter/codelldb",
}

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

