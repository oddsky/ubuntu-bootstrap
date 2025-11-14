local map = vim.keymap.set
local bind = vim.api.nvim_create_user_command
local bind_default_opts = { bang = true }

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Swap buffers
map("n", "<leader><Tab>", "<C-^>")

-- nvim-neo-tree/neo-tree.nvim
map("n", "<leader>e", "<CMD>Neotree float toggle reveal<CR>")
map("n", "<leader>q", "<CMD>Neotree right toggle reveal<CR>")

-- lewis6991/gitsigns.nvim
map("n", "gb", "<CMD>Gitsigns blame_line<CR>")
map("n", "dz", "<CMD>Gitsigns diffthis<CR>")

-- ibhagwan/fzf-lua
map("n", "<leader>pf", "<CMD>FzfLua files<CR>")
map("n", "<leader>pg", "<CMD>FzfLua live_grep_native<CR>")
map("n", "<leader>pd", "<CMD>FzfLua diagnostics_workspace<CR>")
map("n", "<leader>pb", "<CMD>FzfLua buffers<CR>")
map("n", "<leader>ph", "<CMD>FzfLua helptags<CR>")
map("n", "<leader>pc", "<CMD>FzfLua grep_cword<CR>")
map("n", "<leader>r", "<CMD>FzfLua resume<CR>")
map("n", "<leader>pp", "<CMD>FzfLua<CR>")

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
map("n", "<leader>D", "<CMD>tabclose<CR>")
map("n", "<leader>g", "<CMD>tab G<CR>")
map("n", "<leader>0", "<CMD>e ~/places/git/personal/second-brain/scratch.md<CR>")

bind("Tmp", "e ~/places/git/personal/second-brain/scratch.md", bind_default_opts)
bind("W", "w", bind_default_opts)
bind("Q", "q", bind_default_opts)
bind("X", "x", bind_default_opts)

bind("Gb", "G branch -a -vvv", bind_default_opts)
bind("Gp", "G push", bind_default_opts)
bind("Gfe", "G fetch origin", bind_default_opts)
bind("Gca", "G commit --amend", bind_default_opts)
bind("Grm", "G rebase master", bind_default_opts)
bind("Gpf", "G push --force", bind_default_opts)
