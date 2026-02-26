local pak = vim.pack.add

pak({
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/norcalli/nvim-colorizer.lua",
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
    scope = { enabled = false },
    static = { highlights = { "Indent" } },
})

pak({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "master" } })
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "go",
        "groovy",
        "helm",
        "java",
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
        ["google-java-format"] = {
            prepend_args = { "--aosp" },
        },
    },
    formatters_by_ft = {
        java = { "google-java-format" },
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
        markdown = { "prettier", "cbfmt" },
        toml = { "taplo" },
        go = { "gofumpt" },
    },
})

pak({ "https://github.com/echasnovski/mini.nvim" })
require("mini.move").setup() -- Move any selection in any direction
require("mini.bufremove").setup() -- Remove buffers
require("mini.comment").setup() -- Comment lines

pak({ "https://github.com/ibhagwan/fzf-lua" })
require("fzf-lua").setup({
    fzf_colors = true,
    files = {
        formatter = "path.filename_first",
        cwd_prompt = false,
        follow = true,
    },
    grep = { follow = true },
    winopts = {
        border = "single",
        fullscreen = true,
        preview = {
            border = "single",
            scrollbar = false,
        },
    },
})

pak({
    "https://github.com/nvim-neo-tree/neo-tree.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/MunifTanjim/nui.nvim",
})

require("neo-tree").setup({
    filesystem = {
        window = {
            mappings = { ["o"] = "system_open" },
        },
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = { ".git" },
            hide_by_pattern = { ".aider*" },
            always_show_by_pattern = { ".env*" },
            always_show = {
                ".dockerignore",
                ".gitignore",
                ".helmignore",
            },
        },
    },
})

pak({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })
require("treesitter-context").setup({ multiline_threshold = 5 })

pak({ "https://github.com/nvim-pack/nvim-spectre" })
