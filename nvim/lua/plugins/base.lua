return {
  {
	"folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
			-- vim.cmd([[colorscheme tokyonight]])
    end,
  },

	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1001,
		config = function()
			--vim.opt.background = "light"
			--vim.cmd([[colorscheme oxocarbon]])
		end,
	},

	{
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
	},

	{
		"kdheepak/monochrome.nvim",
		lazy = false,
		priority = 1002,
		config = function()
--			vim.cmd([[colorscheme monochrome]])
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		lazy = false,
		build = ":TSUpdate",
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
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup()
		end,
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

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
		  "hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	}
}
