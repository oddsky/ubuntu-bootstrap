local map = vim.keymap.set
local bind = function(name, val)
    vim.api.nvim_create_user_command(name, val, { bang = true })
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear search hl
map("n", "<leader><Tab>", "<C-^>") -- Swap buffers

-- nvim-neo-tree/neo-tree.nvim
map("n", "<leader>e", "<CMD>Neotree float toggle reveal<CR>")
map("n", "<leader>q", "<CMD>Neotree left toggle reveal<CR>")

map("n", "gb", "<CMD>Gitsigns blame_line<CR>")
map("n", "dz", "<CMD>Gitsigns diffthis<CR>")

map("n", "<leader>pf", "<CMD>FzfLua files<CR>")
map("n", "<leader>pg", "<CMD>FzfLua live_grep_native<CR>")
map("n", "<leader>pd", "<CMD>FzfLua diagnostics_document<CR>")
map("n", "<leader>pb", "<CMD>FzfLua buffers<CR>")
map("n", "<leader>ph", "<CMD>FzfLua helptags<CR>")
map("n", "<leader>pc", "<CMD>FzfLua grep_cword<CR>")
map("n", "<leader>r", "<CMD>FzfLua resume<CR>")
map("n", "<leader>pp", "<CMD>FzfLua<CR>")

map("n", "<leader>d", require("mini.bufremove").delete)
map("n", "gS", require("mini.splitjoin").toggle)

map("n", "fr", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end)

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

map("n", "<leader>D", "<CMD>tabclose<CR>")
map("n", "<leader>g", "<CMD>tab G<CR>")
map("n", "<leader>0", "<CMD>e ~/places/git/personal/second-brain/scratch.md<CR>")
map("v", "<leader>r", ":'<,'>:w !tmux load-buffer -; tmux paste-buffer -t 1.1<CR>")

bind("W", "w")
bind("Q", "q")
bind("X", "x")

bind("Gp", "G push")
bind("Gfe", "G fetch origin")
bind("Gca", "G commit --amend")
bind("Grm", "G rebase master")
bind("Gpf", "G push --force")
