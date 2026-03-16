-- stylua: ignore start
local colors = {
    red          =  "#F17474",
    orange       =  "#EFA876",
    yellow       =  "#D5C15D",
    green        =  "#78BA78",
    cyan         =  "#6DA6AB",
    blue         =  "#7D8FE8",
    violet       =  "#A284CD",
    search       =  "#3A370D",
    visual       =  "#14293D",
    bg_diff_add  =  "#152815",
    bg_diff_del  =  "#310C0C",
    bg1          =  "#1E1F22",
    bg2          =  "#26282E",
    bg3          =  "#2E3038",
    bg4          =  "#383A3E",
    fg2          =  "#666666",
    fg1          =  "#D9D9D9",
}
-- stylua: ignore end

vim.opt.background = "dark"
require("utils.hls").load(colors)
