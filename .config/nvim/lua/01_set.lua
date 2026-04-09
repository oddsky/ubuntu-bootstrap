local obj = vim.system({ "gsettings", "get", "org.gnome.desktop.interface", "color-scheme" }):wait()
if obj.code == 0 and obj.stdout:find("default") then
    vim.cmd.colorscheme("oddsky_light")
else
    vim.cmd.colorscheme("oddsky_dark")
end

vim.opt.cursorline = true -- Highlight current line
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.number = true -- Line numbers
vim.opt.undofile = true -- Persistent undo
vim.opt.scrolloff = 999 -- Keep cursor in the middle of the screen
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard

vim.opt.cmdheight = 0
vim.opt.laststatus = 3

vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search

vim.opt.syntax = "ON"
vim.opt.smartindent = true -- autoindent new lines
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- shift 4 spaces when tab
vim.opt.tabstop = 4 -- 1 tab == 4 spaces

vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

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
        [".*/templates/.*%.yaml"] = "helm",

        [".*/values/.*%.yaml.gotmpl"] = "helm",
        [".*/values/.*%.yaml"] = "helm",

        [".*/helm%-defaults/.*%.yaml.gotmpl"] = "helm",
        [".*/helm%-defaults/.*%.yaml"] = "helm",

        [".*/helmfiles?/.*%.yaml.gotmpl"] = "helm",
        [".*/helmfiles?/.*%.yaml"] = "helm",

        ["helmfile.*%.yaml.gotmpl"] = "helm",
        ["helmfile.*%.yaml"] = "helm",

        ["values.yaml.gotmpl"] = "helm",
    },
})
