return {
	{
		"mfussenegger/nvim-dap",
		  keys = {
    {
      "<leader>db",
      function() require("dap").toggle_breakpoint() end,
      desc = "Toggle Breakpoint"
    },

    {
      "<leader>dc",
      function() require("dap").continue() end,
      desc = "Continue"
    },

    {
      "<leader>dC",
      function() require("dap").run_to_cursor() end,
      desc = "Run to Cursor"
    },

    {
      "<leader>dT",
      function() require("dap").terminate() end,
      desc = "Terminate"
    },
	}
	},
	{
  "jay-babu/mason-nvim-dap.nvim",
  ---@type MasonNvimDapSettings
  opts = {
    -- This line is essential to making automatic installation work
    -- :exploding-brain
    handlers = {},
    automatic_installation = {
      -- These will be configured by separate plugins.
      exclude = {
        "delve",
        "python",
      },
    },
    -- DAP servers: Mason will be invoked to install these if necessary.
    ensure_installed = {
      "bash",
      "codelldb",
      "php",
      "python",
    },
  },
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
}
}
