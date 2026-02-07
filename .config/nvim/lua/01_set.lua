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
vim.opt.cmdwinheight = 20

-- search
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show matches as you type

-- tabs
vim.opt.syntax = "ON"
vim.opt.smartindent = true -- autoindent new lines
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- shift 4 spaces when tab
vim.opt.tabstop = 4 -- 1 tab == 4 spaces

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- How long to show matching bracket

-- Key mappings
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set local leader key (NEW)

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    callback = function()
        vim.highlight.on_yank()
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
