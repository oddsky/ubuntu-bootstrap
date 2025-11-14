local hl = function(name, val)
    vim.api.nvim_set_hl(0, name, val)
end

local M = {}

local function hsl_to_hex_css_str(css_str)
    local h, s, l = css_str:match("hsl%(%s*([%d%.]+)%s*,%s*([%d%.]+)%%%s*,%s*([%d%.]+)%%%s*%)")
    if not h or not s or not l then
        error("Invalid CSS hsl() string: " .. tostring(css_str))
    end

    h = tonumber(h)
    s = tonumber(s) / 100
    l = tonumber(l) / 100

    local function hue2rgb(p, q, t)
        if t < 0 then
            t = t + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        end
        if t < 1 / 2 then
            return q
        end
        if t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end

    h = (h % 360) / 360

    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1 / 3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1 / 3)
    end

    local function tohex(x)
        return string.format("%02x", math.floor(x * 255 + 0.5))
    end

    return "#" .. tohex(r) .. tohex(g) .. tohex(b)
end

-- stylua: ignore start
M.colors = {
    red     =  hsl_to_hex_css_str("hsl(0   ,82%  ,70%)"),
    orange  =  hsl_to_hex_css_str("hsl(25  ,79%  ,70%)"),
    yellow  =  hsl_to_hex_css_str("hsl(50  ,59%  ,60%)"),
    green   =  hsl_to_hex_css_str("hsl(120 ,32%  ,60%)"),
    cyan    =  hsl_to_hex_css_str("hsl(185 ,27%  ,55%)"),
    blue    =  hsl_to_hex_css_str("hsl(230 ,70%  ,70%)"),
    violet  =  hsl_to_hex_css_str("hsl(265 ,42%  ,66%)"),
    search  =  hsl_to_hex_css_str("hsl(57  ,62%  ,21%)"),
    visual  =  hsl_to_hex_css_str("hsl(210 ,62%  ,21%)"),
    bg1    =  "#181818",
    bg2    =  hsl_to_hex_css_str("hsl(0   ,0%   ,18%)"),
    bg3    =  hsl_to_hex_css_str("hsl(0   ,0%   ,22%)"),
    fg2    =  hsl_to_hex_css_str("hsl(0   ,0%   ,42%)"),
    fg1    =  hsl_to_hex_css_str("hsl(0   ,0%   ,80%)"),
}
-- stylua: ignore end
M.set = function(colors)
    -- UI highlight
    hl("Normal", { fg = colors.fg1, bg = colors.bg1 })
    hl("NormalFloat", { fg = colors.fg1 })
    hl("FloatBorder", { fg = colors.fg2 })
    hl("ColorColumn", { bg = colors.bg2 })
    hl("Cursor", { fg = colors.fg2, bg = colors.fg1 })
    hl("CursorLine", { bg = colors.bg2 })
    hl("CursorColumn", { bg = colors.bg2 })
    hl("Directory", { fg = colors.fg1 })
    hl("DiffAdd", { fg = colors.green })
    hl("DiffAdded", { link = "DiffAdd" })
    hl("DiffChange", { fg = colors.orange })
    hl("DiffDelete", { fg = colors.red })
    hl("DiffRemoved", { link = "DiffDelete" })
    hl("DiffText", { fg = colors.orange })
    hl("EndOfBuffer", { bg = "NONE", fg = colors.bg1 })
    hl("ErrorMsg", { fg = colors.red, underline = true })
    hl("VertSplit", { fg = colors.bg2 })
    hl("WinSeparator", { fg = colors.fg2 })
    hl("Folded", { fg = colors.fg2 })
    hl("FoldColumn", { fg = colors.fg2 })
    hl("SignColumn", { fg = colors.fg1 })
    hl("Search", { fg = colors.fg1, bg = colors.search })
    hl("IncSearch", { link = "Search" })
    hl("CurSearch", { link = "Search" })
    hl("LineNr", { fg = colors.fg2 })
    hl("CursorLineNr", { fg = colors.yellow, bg = colors.bg2 })
    hl("MatchParen", { fg = colors.fg1 })
    hl("ModeMsg", { fg = colors.fg1, bg = colors.bg2 })
    hl("MoreMsg", { fg = colors.fg1, bg = colors.bg2 })
    hl("NonText", { fg = colors.fg2 })
    hl("Pmenu", { fg = colors.fg1, bg = colors.bg2 })
    hl("PmenuSel", { fg = colors.fg1, bg = colors.fg2 })
    hl("PmenuSbar", { bg = colors.fg2 })
    hl("PmenuThumb", { bg = colors.fg2 })
    hl("Question", { fg = colors.blue })
    hl("SpecialKey", { fg = colors.fg1 })
    hl("StatusLine", { fg = colors.fg2, bg = colors.bg2, italic = true })
    hl("StatusLineNC", { fg = colors.fg2, bg = colors.bg2, italic = true })
    hl("TabLine", { fg = colors.fg2, bg = colors.bg1 })
    hl("TabLineFill", { fg = colors.fg2, bg = colors.bg1 })
    hl("TablineSel", { fg = colors.fg1, bg = colors.bg3 })
    hl("Title", { italic = true })
    hl("Visual", { bg = colors.visual })
    hl("VisualNOS", { bg = colors.visual })
    hl("WarningMsg", { fg = colors.yellow, bold = true })
    hl("WildMenu", { fg = colors.fg1, bg = colors.blue })
    hl("Comment", { fg = colors.fg2, italic = true })
    hl("Constant", { fg = colors.violet })
    hl("String", { fg = colors.green })
    hl("Character", { fg = colors.cyan })
    hl("Number", { fg = colors.violet })
    hl("Boolean", { fg = colors.violet })
    hl("Float", { fg = colors.violet })
    hl("Identifier", { fg = colors.orange })
    hl("Function", { fg = colors.blue })
    hl("Statement", { fg = colors.violet })
    hl("Conditional", { fg = colors.orange, bold = true })
    hl("Repeat", { fg = colors.violet })
    hl("Label", { fg = colors.violet })
    hl("Operator", { fg = colors.fg1 })
    hl("Keyword", { fg = colors.orange, bold = true })
    hl("Exception", { fg = colors.orange })
    hl("PreProc", { fg = colors.violet })
    hl("Include", { fg = colors.orange, bold = true })
    hl("Define", { fg = colors.yellow, bold = true })
    hl("Macro", { fg = colors.yellow, bold = true })
    hl("Type", { fg = colors.cyan, bold = true })
    hl("StorageClass", { fg = colors.cyan, bold = true })
    hl("Typedef", { fg = colors.cyan, bold = true })
    hl("Structure", { fg = colors.yellow })
    hl("Special", { fg = colors.red })
    hl("SpecialChar", { fg = colors.red })
    hl("Tag", { fg = colors.cyan })
    hl("Delimiter", { fg = colors.fg1 })
    hl("SpecialComment", { link = "Comment" })
    hl("Debug", { fg = colors.fg1 })
    hl("Underlined", { underline = true })
    hl("Ignore", { fg = colors.fg1 })
    hl("Error", { fg = colors.red, underline = true })
    hl("Todo", { fg = colors.orange, bold = true })
    hl("SpellBad", { fg = colors.red, underline = true, sp = colors.red })
    hl("SpellCap", { fg = colors.red, underline = true, sp = colors.red })
    hl("SpellRare", { fg = colors.red, underline = true, sp = colors.red })
    hl("SpellLocale", { fg = colors.red, underline = true, sp = colors.red })
    hl("Whitespace", { fg = colors.fg2 })

    --- Treesitter highlight
    hl("@error", { fg = colors.red })
    hl("@text.literal", { fg = colors.fg1 })
    hl("@text.title", { fg = colors.cyan, bold = true })
    hl("@text.emphasis", { italic = true })
    hl("@text.strong", { bold = true })
    hl("@text.uri", { fg = colors.blue, underline = true })
    hl("@textReference", { fg = colors.blue })
    hl("@text.underline", { underline = true })
    hl("@text.todo", { fg = colors.orange, bold = true })
    hl("@text.note", { fg = colors.green, bold = true })
    hl("@text.warning", { fg = colors.yellow, bold = true })
    hl("@text.danger", { fg = colors.red, bold = true })
    hl("@comment", { link = "Comment" })
    hl("@punctuation", { fg = colors.fg1 })
    hl("@punctuation.special", { fg = colors.cyan })
    hl("@punctuation.bracket", { fg = colors.fg1 })
    hl("@punctuation.delimiter", { fg = colors.fg1 })
    hl("@constant", { fg = colors.fg1 })
    hl("@constant.macro", { fg = colors.yellow, bold = true })
    hl("@define", { fg = colors.yellow, bold = true })
    hl("@macro", { fg = colors.yellow, bold = true })
    hl("@string", { fg = colors.green })
    hl("@string.escape", { fg = colors.blue })
    hl("@stringEscape", { fg = colors.blue })
    hl("@string.special", { fg = colors.blue })
    hl("@string.regex", { fg = colors.violet })
    hl("@character", { fg = colors.cyan })
    hl("@character.special", { fg = colors.blue })
    hl("@number", { fg = colors.violet })
    hl("@boolan", { fg = colors.violet, bold = true })
    hl("@float", { fg = colors.cyan })
    hl("@function", { fg = colors.cyan })
    hl("@function.builtin", { link = "@function" })
    hl("@function.macro", { fg = colors.blue, bold = true })
    hl("@attribute", { fg = colors.orange })
    hl("@annotation", { fg = colors.yellow })
    hl("@parameter", { fg = colors.orange })
    hl("@parameter.reference", { fg = colors.orange })
    hl("@method", { fg = colors.blue })
    hl("@field", { fg = colors.cyan })
    hl("@property", { fg = colors.blue })
    hl("@constructor", { fg = colors.fg1 })
    hl("@conditional", { fg = colors.orange, bold = true })
    hl("@repeat", { fg = colors.orange, bold = true })
    hl("@label", { fg = colors.violet, italic = true })
    hl("@operator", { fg = colors.fg1 })
    hl("@keyword", { fg = colors.red })
    hl("@keyword.function", { fg = colors.blue })
    hl("@keyword.operator", { fg = colors.orange })
    hl("@exception", { fg = colors.orange, bold = true })
    hl("@variable", { fg = colors.fg1 })
    hl("@variable.builtin", { fg = colors.violet })
    hl("@variable.parameter", { fg = colors.orange, italic = true })
    hl("@type", { fg = colors.yellow })
    hl("@type.builtin", { link = "@type" })
    hl("@type.qualifire", { fg = colors.cyan })
    hl("@type.definition", { fg = colors.cyan, bold = true })
    hl("@storageclass", { fg = colors.orange, bold = true })
    hl("@structure", { fg = colors.cyan, bold = true })
    hl("@namespace", { fg = colors.orange })
    hl("@include", { fg = colors.orange, bold = true })
    hl("@preproc", { fg = colors.orange })
    hl("@debug", { fg = colors.yellow })
    hl("@tag", { fg = colors.cyan })
    hl("@tag.delimiter", { fg = colors.fg1 })
    hl("@tag.attribute", { fg = colors.orange })

    -- python
    hl("@constructor.python", { fg = colors.yellow })
    hl("@module.python", { fg = colors.fg1 })
    hl("@string.documentation.python", { link = "Comment" })

    -- markdown
    hl("@markup.heading.1.markdown", { fg = colors.red, italic = true })
    hl("@markup.heading.2.markdown", { fg = colors.orange, italic = true })
    hl("@markup.heading.3.markdown", { fg = colors.yellow, italic = true })
    hl("@markup.heading.4.markdown", { fg = colors.green, italic = true })

    -- json
    hl("@property.json", { fg = colors.blue, bold = true })

    -- LSP semantic tokens
    hl("@lsp.type.class", { link = "@type" })
    hl("@lsp.type.decorator", { link = "@function" })
    hl("@lsp.type.enum", { link = "@structure" })
    hl("@lsp.type.enumMember", { link = "@property" })
    hl("@lsp.type.function", { link = "@function" })
    hl("@lsp.type.interface", { link = "@type" })
    hl("@lsp.type.macro", { link = "@macro" })
    hl("@lsp.type.method", { link = "@function" })
    hl("@lsp.type.namespace", { link = "@namespace" })
    hl("@lsp.type.parameter", { link = "@parameter" })
    hl("@lsp.type.property", { link = "@property" })
    hl("@lsp.type.struct", { link = "@structure" })
    hl("@lsp.type.type", { link = "@type" })
    hl("@lsp.type.typeParameter", { link = "@type" })
    hl("@lsp.type.variable", { link = "@variable" })
    hl("@lsp.type.keyword", { link = "@keyword" })

    hl("htmlTag", { fg = colors.cyan })
    hl("htmlEndTag", { fg = colors.cyan })
    hl("htmlTagName", { fg = colors.cyan })
    hl("htmlSpecialTagName", { fg = colors.cyan })
    hl("htmlArg", { fg = colors.orange })

    -- hl("BufferLineIndicatorSelected", { bg = colors.bg1 })
    hl("BufferLineFill", { bg = colors.bg2 })

    hl("LspReferenceText", { bg = colors.search })
    hl("LspReferenceRead", { bg = colors.blue })
    hl("LspReferenceWrite", { bg = colors.blue })

    hl("DiagnosticUnderlineError", { underline = false, undercurl = false })
    hl("DiagnosticUnderlineWarn", { underline = false, undercurl = false })
    hl("DiagnosticUnderlineInfo", { underline = false, undercurl = false })
    hl("DiagnosticUnderlineHint", { underline = false, undercurl = false })
    hl("DiagnosticUnnecessary", { fg = colors.fg2, italic = true })

    hl("DiagnosticError", { fg = colors.red, italic = true })
    hl("DiagnosticWarn", { fg = colors.yellow, italic = true })
    hl("DiagnosticHint", { fg = colors.blue, italic = true })
    hl("DiagnosticInfo", { fg = colors.cyan, italic = true })

    hl("GitSignsAdd", { fg = colors.green })
    hl("GitSignsChange", { fg = colors.yellow })
    hl("GitSignsDelete", { fg = colors.red })

    -- indent-blankline
    hl("Indent", { link = "VertSplit" })

    -- FzfLua
    hl("FzfLuaBorder", { link = "VertSplit" })
end

M.setup = function()
    vim.cmd("hi clear")

    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.termguicolors = true
    vim.g.colors_name = "oddsky"

    M.set(M.colors)
end

M.setup()
