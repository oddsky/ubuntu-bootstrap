-- stylua: ignore start
local colors = {
    red          =  "#e77e7e",
    orange       =  "#e5aa80",
    yellow       =  "#ccbb66",
    green        =  "#7bb77b",
    cyan         =  "#73a6ab",
    blue         =  "#8594e0",
    violet       =  "#a389c8",
    search       =  "#534f13",
    visual       =  "#213445",
    bg_diff_add  =  "#1f4729",
    bg_diff_del  =  "#471f1f",
    bg1          =  "#222225",
    bg2          =  "#28282a",
    bg3          =  "#38383d",
    bg4          =  "#404045",
    fg2          =  "#646468",
    fg1          =  "#D9D9D9",
}
-- stylua: ignore end

vim.opt.background = "dark"
require("utils.hls").load(colors)
