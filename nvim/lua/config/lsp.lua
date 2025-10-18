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

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("AutoFormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      if client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ async = false })
        return
      end
    end
  end,
})
