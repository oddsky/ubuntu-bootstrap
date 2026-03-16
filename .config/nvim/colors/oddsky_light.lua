-- stylua: ignore start
local colors = {
    red          =  "#cc372e",
    orange       =  "#e17d19",
    yellow       =  "#cdac08",
    green        =  "#26a439",
    cyan         =  "#089dcb",
    blue         =  "#0869cb",
    violet       =  "#9647bf",
    search       =  "#f5f4d6",
    visual       =  "#d9e6f2",
    bg_diff_add  =  "#bcdcbc",
    bg_diff_del  =  "#ebadad",
    bg1          =  "#feffff",
    bg2          =  "#e6e6e6",
    bg3          =  "#b3b3b3",
    bg4          =  "#999999",
    fg2          =  "#8c8c8c",
    fg1          =  "#1a1a1a",
}
-- stylua: ignore end

vim.opt.background = "light"
require("utils.hls").load(colors)
