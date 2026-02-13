vim.cmd.colorscheme("oddsky")

vim.opt.cursorline = true -- Highlight current line
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.number = true -- Line numbers
vim.opt.undofile = true -- Persistent undo
vim.opt.scrolloff = 999 -- Keep cursor in the middle of the screen
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard

vim.opt.winborder = "single"
vim.opt.cmdheight = 0
vim.opt.laststatus = 3

-- search
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search

-- tabs
vim.opt.syntax = "ON"
vim.opt.smartindent = true -- autoindent new lines
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- shift 4 spaces when tab
vim.opt.tabstop = 4 -- 1 tab == 4 spaces

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- Key mappings
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set local leader key (NEW)

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man" },
    callback = function()
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 80")
    end,
})

vim.filetype.add({
    pattern = {
        [".*/templates/.*%.tpl"] = "helm",
        [".*/templates/.*%.ya?ml"] = "helm",
        [".*/values/.*%.ya?ml.gotmpl"] = "helm",
        [".*/values/.*%.ya?ml"] = "helm",
        [".*/helmfiles?/.*%.ya?ml"] = "helm",
        [".*/helmfiles?/.*%.ya?ml.gotmpl"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
        ["helmfile.*%.ya?ml.gotmpl"] = "helm",
        ["values.yaml.gotmpl"] = "helm",
    },
})
