local pak = vim.pack.add

pak({
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/armyers/Vim-Jinja2-Syntax",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/maxmx03/solarized.nvim",
})

pak({ "https://github.com/ThePrimeagen/harpoon" })
require("harpoon").setup({
    menu = {
        width = math.floor(vim.o.columns * 0.7),
    },
})

pak({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.0") } })
require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
    },
    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
    },
})

pak({ "https://github.com/saghen/blink.indent" })
require("blink.indent").setup({
    static = {
        highlights = { "Indent" },
    },
    scope = { enabled = false },
})

pak({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "master" } })
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "go",
        "groovy",
        "helm",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },
    highlight = { enable = true },
})

pak({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })
require("tiny-inline-diagnostic").setup({
    preset = "powerline",
    options = { show_source = true },
})

pak({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
    formatters = {
        stylua = {
            prepend_args = { "--indent-type", "Spaces" },
        },
        cbfmt = {
            prepend_args = { "--config", "/home/rrossamakhin/.config/nvim/cbfmt.toml" },
        },
    },
    formatters_by_ft = {
        lua = { "stylua" },
        python = {
            "ruff_format",
            "ruff_organize_imports",
            "ruff_fix",
        },
        sh = { "beautysh" },
        zsh = { "beautysh" },
        sql = { "sqlfmt" },
        json = { "fixjson" },
        markdown = { "cbfmt" },
        toml = { "taplo" },
        go = { "gofumpt" },
    },
})

-- pak({
--     "https://github.com/nvim-neo-tree/neo-tree.nvim",
--     "https://github.com/nvim-lua/plenary.nvim",
--     "https://github.com/nvim-tree/nvim-web-devicons",
--     "https://github.com/MunifTanjim/nui.nvim",
--     "https://github.com/s1n7ax/nvim-window-picker",
-- })
--
-- require("neo-tree").setup({
--     commands = {
--         system_open = function(state)
--             local path = state.tree:get_node():get_id()
--             vim.fn.jobstart({ "xdg-open", path }, { detach = true })
--         end,
--     },
--     filesystem = {
--         window = {
--             mappings = {
--                 ["o"] = "system_open",
--             },
--         },
--         filtered_items = {
--             hide_dotfiles = false,
--             hide_gitignored = false,
--             hide_by_name = { ".git" },
--             always_show_by_pattern = { ".env*" },
--             always_show = {
--                 ".dockerignore",
--                 ".gitignore",
--                 ".helmignore",
--             },
--         },
--     },
-- })

pak({ "https://github.com/echasnovski/mini.nvim" })
require("mini.move").setup() -- Move any selection in any direction
require("mini.bufremove").setup() -- Remove buffers
require("mini.comment").setup() -- Comment lines

pak({ "https://github.com/kylechui/nvim-surround" })
require("nvim-surround").setup({})

pak({ "https://github.com/ibhagwan/fzf-lua" })
require("fzf-lua").setup({
    fzf_colors = true,
    files = {
        formatter = "path.filename_first",
        cwd_prompt = false,
        follow = true,
    },
    grep = {
        follow = true,
    },
    winopts = {
        border = "single",
        fullscreen = true,
        preview = {
            border = "single",
            scrollbar = false,
        },
    },
})
