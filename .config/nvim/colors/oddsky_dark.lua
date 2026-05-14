-- stylua: ignore start
local colors = {
    red          =  "#e77e7e",
    orange       =  "#e5aa80",
    yellow       =  "#ccbb66",
    green        =  "#7bb77b",
    cyan         =  "#73a6ab",
    blue         =  "#8594e0",
    violet       =  "#a389c8",
    search       =  "#3A370D",
    visual       =  "#152432",
    bg_diff_add  =  "#152815",
    bg_diff_del  =  "#310C0C",
    bg1          =  "#282725",
    bg2          =  "#302f2c",
    bg3          =  "#403e3b",
    bg4          =  "#484642",
    fg2          =  "#666666",
    fg1          =  "#D9D9D9",
}
-- stylua: ignore end

vim.opt.background = "dark"
require("utils.hls").load(colors)
