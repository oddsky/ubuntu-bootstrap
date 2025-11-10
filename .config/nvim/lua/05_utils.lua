local Job = require("plenary.job")

local function pop_temp_buff(content)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.cmd("tabnew")
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_buf_set_name(buf, "[temp tab]")
end

local function get_visual_selection()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local start_line = start_pos[2]
    local end_line = end_pos[2]
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    if #lines == 0 then
        vim.notify("Nothing selected", vim.log.levels.ERROR)
        return nil
    end
    local indent = string.match(lines[1], "^%s*") or ""
    for i, l in ipairs(lines) do
        lines[i] = l:gsub("^" .. indent, "")
    end
    return table.concat(lines, "\n")
end

local function certinfo_to_scratch()
    local job_opts = {
        command = "openssl",
        args = { "x509", "-noout", "-subject", "-issuer", "-dates", "-text" },
        writer = get_visual_selection(),
        on_exit = function(j, return_val)
            local stdout = table.concat(j:result(), "\n")
            local stderr = table.concat(j:stderr_result(), "\n")
            local content = ""
            if return_val ~= 0 then
                content = ("Return code: %d\nStderr:\n%s"):format(return_val, stderr)
            else
                content = stdout
            end
            vim.schedule(function()
                pop_temp_buff(content)
            end)
        end,
    }
    Job:new(job_opts):start()
end

vim.api.nvim_create_user_command(
    "CertInfo",
    certinfo_to_scratch,
    { range = true, desc = "Показать x509-информацию в scratch-буфере" }
)
