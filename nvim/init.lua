require("config.lazy")

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

-- terminal mode is annoying :/
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true })

-- use zsh
vim.opt.shell = "/usr/bin/zsh"

-- Setup the LSP stuff
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}
})

local caps = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

-- clangd
vim.lsp.config("clangd", {
  cmd = { "clangd", "--compile-commands-dir=build" },
  capabilities = caps,
  on_attach = on_attach,
})
vim.lsp.enable("clangd")

-- rust-analyzer
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
  capabilities = caps,
  on_attach = on_attach,
})
vim.lsp.enable("rust_analyzer")

-- typescript
vim.lsp.config("ts_ls", {
  capabilities = caps,
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
})
vim.lsp.enable("ts_ls")

-- gopls
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
    },
  },
  capabilities = caps,
  on_attach = on_attach,
})
vim.lsp.enable("gopls")

-- pyright
vim.lsp.config("pyright", {
	capabilities = caps,
})

local notify = require("notify")

vim.defer_fn(function()
  local cmake = require("config.cmake").find_cmake()
  if cmake and cmake ~= "cmake" then
		--vim.notify("CMake found at: " .. cmake, vim.log.levels.INFO, { title = "Build System" })
  end
end, 1000)

-- 1) resolve cmake once
local function find_cmake()
  local p = vim.fn.exepath("cmake")
  if p ~= "" then return p end
  for _, f in ipairs({"/opt/homebrew/bin/cmake","/usr/local/bin/cmake","/usr/bin/cmake"}) do
    if vim.fn.filereadable(f) == 1 then return f end
  end
  return "cmake" -- last-ditch; may still fail
end
local CMAKE = find_cmake()

-- 2) tiny float-term helper
local function float_term(cmd, opts)
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
        vim.notify(("build exited %d"):format(code), code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
      end)
    end,
    env = opts.env,              -- e.g. env = { PATH = os.getenv("PATH") }
  })

  vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = buf, silent = true })
  return job
end

-- 3) configure without shell; mkdir via Lua; use cwd + argv form
local function configure_cmake(build_type)
  vim.fn.mkdir("build", "p")
  float_term(
    { CMAKE, "-DCMAKE_BUILD_TYPE=" .. build_type, "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", ".." },
    { cwd = "build" }
  )
end

vim.keymap.set("n", "<leader>cd", function() configure_cmake("Debug") end,          { desc = "CMake Debug" })
vim.keymap.set("n", "<leader>cr", function() configure_cmake("Release") end,        { desc = "CMake Release" })
vim.keymap.set("n", "<leader>cp", function() configure_cmake("RelWithDebInfo") end, { desc = "CMake RelWithDebInfo" })

-- 4) build target (no shell, proper argv, cwd)
vim.api.nvim_create_user_command("Build", function(opts)
  local t = opts.args
  if t == "" then print("Usage: :Build <target>"); return end
  float_term(
    { CMAKE, "--build", "build", "--parallel", "20", "--target", t },
    { height_ratio = 0.8, width_ratio = 0.8, border = "single" }
  )
end, { nargs = 1 })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("AutoFormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.keymap.set('n', '<leader>cs', function()
  require('telescope.builtin').colorscheme({
    enable_preview = true  -- live preview
  })
end, { desc = "Pick a colorscheme" })

vim.keymap.set("n", "<leader>r", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true })

vim.cmd('colorscheme koehler')

