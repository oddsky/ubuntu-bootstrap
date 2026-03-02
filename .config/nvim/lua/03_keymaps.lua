vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear search hl
vim.keymap.set("n", "<leader><Tab>", "<C-^>") -- Swap buffers

-- jump to upwards context
vim.keymap.set("n", "[c", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

vim.keymap.set("n", "<leader>e", "<CMD>Neotree float toggle reveal<CR>")
vim.keymap.set("n", "<leader>q", "<CMD>Neotree left toggle reveal<CR>")
vim.keymap.set("n", "<leader>pf", "<CMD>FzfLua files<CR>")
vim.keymap.set("n", "<leader>pg", "<CMD>FzfLua live_grep_native<CR>")
vim.keymap.set("n", "<leader>pd", "<CMD>FzfLua diagnostics_document<CR>")
vim.keymap.set("n", "<leader>pb", "<CMD>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>ph", "<CMD>FzfLua helptags<CR>")
vim.keymap.set("n", "<leader>pc", "<CMD>FzfLua grep_cword<CR>")
vim.keymap.set("n", "<leader>r", "<CMD>FzfLua resume<CR>")
vim.keymap.set("n", "<leader>G", "<CMD>FzfLua git_branches<CR>")
vim.keymap.set("n", "<leader>pp", "<CMD>FzfLua<CR>")
vim.keymap.set("n", "<leader>d", require("mini.bufremove").delete)
vim.keymap.set("n", "gS", require("mini.splitjoin").toggle)

vim.keymap.set("n", "fr", function()
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
vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file)
vim.keymap.set("n", "<C-e>", require("harpoon.ui").toggle_quick_menu)
vim.keymap.set("n", "<leader>1", jump(1))
vim.keymap.set("n", "<leader>2", jump(2))
vim.keymap.set("n", "<leader>3", jump(3))
vim.keymap.set("n", "<leader>4", jump(4))
vim.keymap.set("n", "<leader>D", "<CMD>tabclose<CR>")
vim.keymap.set("n", "<leader>g", "<CMD>tab G<CR>")
vim.keymap.set("n", "<leader>0", "<CMD>e ~/places/git/personal/second-brain/scratch.md<CR>")

vim.api.nvim_create_user_command("W", "w", { bang = true })
vim.api.nvim_create_user_command("Q", "q", { bang = true })
vim.api.nvim_create_user_command("X", "x", { bang = true })
vim.api.nvim_create_user_command("Gp", "G push", { bang = true })
vim.api.nvim_create_user_command("Gca", "G commit --amend", { bang = true })
vim.api.nvim_create_user_command("Grm", "G rebase master", { bang = true })
vim.api.nvim_create_user_command("Gpf", "G push --force", { bang = true })
vim.api.nvim_create_user_command("CertInfo", require("utils.openssl").certinfo_to_scratch, { range = true })

vim.keymap.set("v", "<leader>r", function()
    local s = vim.fn.getpos("v")
    local e = vim.fn.getpos(".")
    local region = vim.fn.getregion(s, e, { type = vim.fn.mode() })
    vim.system({ "tmux", "load-buffer", "-" }, { stdin = region })
    vim.system({ "tmux", "paste-buffer", "-t", "1.1" })
    vim.api.nvim_input("<Esc>")
end)
