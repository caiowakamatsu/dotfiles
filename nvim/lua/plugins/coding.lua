return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>r", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>cs", function()
				require("telescope.builtin").colorscheme({ enable_preview = true })
			end, { desc = "Telescope color theme" })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
		  "hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
	},
}
