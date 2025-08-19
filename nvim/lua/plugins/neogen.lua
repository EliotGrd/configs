return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup({
      enabled = true,
      languages = {
        cpp = { template = { annotation_convention = "doxygen" } },
        c   = { template = { annotation_convention = "doxygen" } },
        python = { template = { annotation_convention = "reST" } }, -- if you want
      },
    })
    vim.keymap.set("n", "<leader>gd", function() require("neogen").generate() end,
      { desc = "Generate Doxygen comment" })
  end
}
