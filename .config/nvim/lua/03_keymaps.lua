local map = vim.keymap.set
local bind = vim.api.nvim_create_user_command
local bind_default_opts = { bang = true }

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Swap buffers
map("n", "<leader><Tab>", "<C-^>")

-- nvim-neo-tree/neo-tree.nvim
map("n", "<leader>e", ":Neotree float toggle<CR>")
map("n", "<leader>E", ":Neotree float reveal<CR>")
map("n", "<leader>q", ":Neotree right toggle<CR>")
map("n", "<leader>Q", ":Neotree right reveal<CR>")

-- lewis6991/gitsigns.nvim
map("n", "gb", ":Gitsigns blame_line<CR>")
map("n", "dz", ":Gitsigns diffthis<CR>")

-- ibhagwan/fzf-lua
map("n", "<leader>pf", ":FzfLua files<CR>")
map("n", "<leader>pg", ":FzfLua live_grep_native<CR>")
map("n", "<leader>pd", ":FzfLua diagnostics_workspace<CR>")
map("n", "<leader>pb", ":FzfLua buffers<CR>")
map("n", "<leader>ph", ":FzfLua helptags<CR>")
map("n", "<leader>pc", ":FzfLua grep_cword<CR>")
map("n", "<leader>r", ":FzfLua resume<CR>")
map("n", "<leader>pp", ":FzfLua<CR>")

-- echasnovski/mini.nvim
map("n", "<leader>d", require("mini.bufremove").delete)
map("n", "gS", require("mini.splitjoin").toggle)

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- stevearc/conform.nvim
map("n", "fr", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end)

-- ThePrimeagen/harpoon
local function jump(num)
    return function()
        require("harpoon.ui").nav_file(num)
    end
end
map("n", "<leader>a", require("harpoon.mark").add_file)
map("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
map("n", "<leader>1", jump(1))
map("n", "<leader>2", jump(2))
map("n", "<leader>3", jump(3))
map("n", "<leader>4", jump(4))

-- custom
map("n", "<leader>D", ":tabclose<CR>")
map("n", "<leader>g", ":tab G<CR>")
map("n", "<leader>0", ":e ~/places/git/personal/second-brain/scratch.md<CR>")
bind("Tmp", "e ~/places/git/personal/second-brain/scratch.md", bind_default_opts)
bind("W", "w", bind_default_opts)
bind("Q", "q", bind_default_opts)
bind("X", "x", bind_default_opts)
bind("Gb", "G branch -vv", bind_default_opts)
bind("Gca", "G commit --amend", bind_default_opts)
bind("Grm", "G rebase master", bind_default_opts)
bind("Gp", "G push", bind_default_opts)
bind("Gpf", "G push --force", bind_default_opts)
