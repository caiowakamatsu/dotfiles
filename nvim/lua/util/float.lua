local M = {}

function M.float_terminal(cmd, opts)
  opts = opts or {}
  local buf = vim.api.nvim_create_buf(false, true)
  local width  = math.floor(vim.o.columns * (opts.width_ratio  or 0.8))
  local height = math.floor(vim.o.lines   * (opts.height_ratio or 0.5))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  vim.api.nvim_open_win(buf, true, {
    style = "minimal", relative = "editor",
    width = width, height = height, row = row, col = col,
    border = opts.border or "rounded",
  })

  local function scroll_bottom()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_cursor(win, {vim.api.nvim_buf_line_count(0), 0})
  end

  local job = vim.fn.termopen(cmd, {
    cwd = opts.cwd,              -- <= important
    on_stdout = function(...) scroll_bottom() end,
    on_stderr = function(...) scroll_bottom() end,
    on_exit = function(_, code, _)
      vim.schedule(function()
        vim.notify(("command exited %d"):format(code), code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
      end)
    end,
    env = opts.env,              -- e.g. env = { PATH = os.getenv("PATH") }
  })

  vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = buf, silent = true })
  return job
end


return M
