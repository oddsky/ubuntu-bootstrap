-- stylua: ignore start
local colors = {
    red          =  "#e87d7d",
    orange       =  "#e7aa7e",
    yellow       =  "#cebc64",
    green        =  "#79b979",
    cyan         =  "#71a8ad",
    blue         =  "#8493e1",
    violet       =  "#a387c9",
    search       =  "#3A370D",
    visual       =  "#213445",
    bg_diff_add  =  "#152815",
    bg_diff_del  =  "#310C0C",
    bg1          =  "#282c34",
    bg2          =  "#2e3238",
    bg3          =  "#303236",
    bg4          =  "#383a3e",
    fg2          =  "#666666",
    fg1          =  "#D9D9D9",
}
-- stylua: ignore end

vim.opt.background = "dark"
require("utils.hls").load(colors)
