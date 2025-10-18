return {
	{
		"xiyaowong/transparent.nvim",
		lazy = false,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
					on_attach = function(bufnr)
						local api = require("nvim-tree.api")

						api.config.mappings.default_on_attach(bufnr)
						vim.keymap.set('n', '<CR>', function()
						local node = api.tree.get_node_under_cursor()
						api.node.open.edit()

						if not node or node.nodes == nil then
							api.tree.close()
						end

					end, { buffer = bufnr, noremap = true, silent = true })
				end,
			})

			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	}
}
