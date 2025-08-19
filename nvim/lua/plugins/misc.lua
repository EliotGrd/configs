return {
    {
    "mbbill/undotree",
    init = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
    },
        {
      "Diogo-ss/42-header.nvim",
      cmd = { "Stdheader" },
      keys = { "<F1>" },
      opts = {
        default_map = true, -- Default mapping <F1> in normal mode.
            auto_update = true, -- Update header when saving.
            user = "egiraud", -- Your user.
            mail = "egiraud@student.42.fr", -- Your mail.
            -- add other options.
      },
      config = function(_, opts)
        require("42header").setup(opts)
      end,
    }, 
    {
    "Diogo-ss/42-C-Formatter.nvim",
    cmd = "CFormat42",
    init = function()
      -- Set up the keybinding for <F2> in the init block
      vim.keymap.set("n", "<F2>", ":CFormat42<CR>", { noremap = true, silent = true })
    end,
    config = function()
      local formatter = require "42-formatter"
      formatter.setup({
        formatter = 'python3 -m c_formatter_42',
        filetypes = { c = true, h = true, cpp = true, hpp = true },
      })
    end
  }
}
