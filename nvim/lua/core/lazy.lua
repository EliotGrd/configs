local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	{import = "plugins"}
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })



local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hbp", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>hbn", function() harpoon:list():next() end)


-- LSP STUFF


--vim.lsp.enable('ccls')

-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
--vim.opt.completeopt = { "menuone", "noselect", "popup" }

--require("lspconfig")["ccls"].setup({
--	on_attach = function(client, bufnr)
  --    vim.lsp.completion.enable(true, client.id, bufnr, {
	--	autotrigger = true,
	--	convert = function(item)
      --    return { abbr = item.label:gsub("%b()", "") }
	--	end,
     -- })
      --vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
    --end
--})
