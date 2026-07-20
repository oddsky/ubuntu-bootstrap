local colors = {
    red = "#e77e7e",
    green = "#7bb77b",
    yellow = "#ccbb66",
    blue = "#8594e0",
    violet = "#a389c8",
    cyan = "#73a6ab",
    orange = "#e5aa80",

    search = "#534f13",
    visual = "#213445",

    bg_diff_add = "#1f4729",
    bg_diff_del = "#471f1f",

    bg1 = "#24292e",
    bg2 = "#2b3036",
    bg3 = "#32373e",
    bg4 = "#393f47",
    fg2 = "#717f8e",
    fg1 = "#d1d5da",
}

vim.opt.background = "dark"
require("utils.hls").load(colors)
