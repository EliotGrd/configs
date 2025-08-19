return {
  "stevearc/overseer.nvim",
  config = function()
    local overseer = require("overseer")
    overseer.setup()

    -- Run Doxygen
    vim.keymap.set("n", "<leader>dx", function()
      overseer.run_template({
        name = "Run Doxygen",
        builder = function()
          return {
            cmd = { "doxygen", "Doxyfile" },
            components = { "default" },
          }
        end,
      })
    end, { desc = "Run doxygen" })

    -- Open docs in browser (works on macOS, Linux, Windows)
    vim.keymap.set("n", "<leader>do", function()
      local html_index = "docs/doxygen/html/index.html"
      local open_cmd
      if vim.fn.has("mac") == 1 then
        open_cmd = { "open", html_index }
      elseif vim.fn.has("unix") == 1 then
        open_cmd = { "xdg-open", html_index }
      elseif vim.fn.has("win32") == 1 then
        open_cmd = { "cmd.exe", "/C", "start", html_index }
      else
        vim.notify("Unsupported system for auto-open", vim.log.levels.WARN)
        return
      end
      vim.fn.jobstart(open_cmd, { detach = true })
    end, { desc = "Open doxygen docs" })
  end
}
