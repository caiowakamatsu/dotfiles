return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  {
    "kdheepak/monochrome.nvim",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  {
		'jesseleite/nvim-noirbuddy',
		dependencies = {
			{ 'tjdevries/colorbuddy.nvim' }
		},
		lazy = false,
		priority = 1000,
		setup = function()
			require('noirbuddy').setup {
				colors = {
					primary = '#6EE2FF',
					secondary = '#267FB5',
				},
			}
		end,
  },
}
