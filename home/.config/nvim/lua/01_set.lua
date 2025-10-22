vim.cmd.colorscheme("oddsky")

vim.opt.spell = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.scrolloff = 999
vim.opt.undofile = true

vim.opt.winborder = "single"

vim.opt.cmdheight = 0
vim.opt.laststatus = 2
vim.opt.statusline = " %f %m %= %l:%v"
vim.opt.cmdwinheight = 10

-- Интеграция с буфером обмена ОС
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
-- vim.opt.incsearch = true

-- Табы и отступы
vim.opt.syntax = "ON"
vim.opt.smartindent = true -- autoindent new lines
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- shift 4 spaces when tab
vim.opt.tabstop = 4 -- 1 tab == 4 spaces

-- Вертикальный сплит направо
vim.o.splitright = true

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99

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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
