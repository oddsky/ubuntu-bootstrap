vim.cmd.colorscheme("oddsky")

vim.opt.spell = false
vim.opt.cursorline = true -- Highlight current line
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.number = true -- Line numbers
vim.opt.undofile = true -- Persistent undo
vim.opt.scrolloff = 999 -- Keep cursor in the middle of the screen
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard

vim.opt.winborder = "single"
vim.opt.cmdheight = 0 -- Command line height
-- vim.opt.statusline = " %f %m %= %l:%v"
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

-- FOLDS SETTINGS

-- Keymaps:
-- zf#j creates a fold from the cursor down # lines.
-- zf/string creates a fold from the cursor to string .
-- zj moves the cursor to the next fold.
-- zk moves the cursor to the previous fold.
-- zo opens a fold at the cursor.
-- zO opens all folds at the cursor.
-- zm increases the foldlevel by one.
-- zM closes all open folds.
-- zr decreases the foldlevel by one.
-- zR decreases the foldlevel to zero -- all folds will be open.
-- zd deletes the fold at the cursor.
-- zE deletes all folds.
-- [z move to start of open fold.
-- ]z move to end of open fold.
--
-- Folding settings
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- Start with all folds open

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
    },
})
