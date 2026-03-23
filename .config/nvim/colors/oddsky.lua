-- stylua: ignore start
local colors = {
    red          =  "#e48181",
    orange       =  "#e3aa82",
    yellow       =  "#c9b969",
    green        =  "#7eb47e",
    cyan         =  "#76a3a7",
    blue         =  "#8896dd",
    violet       =  "#a48cc5",
    search       =  "#3A370D",
    visual       =  "#152432",
    bg_diff_add  =  "#152815",
    bg_diff_del  =  "#310C0C",
    bg1          =  "#1e1e1e",
    bg2          =  "#262626",
    bg3          =  "#333333",
    bg4          =  "#3b3b3b",
    fg2          =  "#666666",
    fg1          =  "#D9D9D9",
}
-- stylua: ignore end

vim.opt.background = "dark"
require("utils.hls").load(colors)
