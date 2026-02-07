-- thanks to kentchiu, ref:
-- https://github.com/kentchiu/aider.nvim/blob/main/lua/aider/file_watcher.lua

local M = {}
local DEBOUNCE_MS = 3000

local handles = {}
local processing_files = {}

local function watch_file()
    local uv = vim.uv
    local fullpath = vim.fn.expand("%:p")
    local filename = vim.fn.fnamemodify(fullpath, ":t")
    local relate_path = vim.fn.fnamemodify(fullpath, ":.")

    if not fullpath or fullpath == "" then
        return
    end

    local bufnr = vim.fn.bufnr(fullpath)
    if bufnr == -1 or vim.bo[bufnr].buftype ~= "" then
        return
    end

    if handles[fullpath] then
        handles[fullpath]:close()
    end

    local handle = uv.new_fs_event()
    handle:start(fullpath, {
        recursive = false,
        stat = true,
        watch_entry = true,
    }, function(err, filename, events)
        if err then
            vim.notify("Error watching file: " .. err, vim.log.levels.ERROR)
            handle:close()
            handles[fullpath] = nil
            return
        end

        local current_stat = vim.loop.fs_stat(fullpath)
        if not current_stat then
            return
        end

        if events.rename then
            handle:close()
            handles[fullpath] = nil
            processing_files[fullpath] = nil
            return
        end

        vim.schedule(function()
            local current_time = vim.loop.now()
            if processing_files[fullpath] and (current_time - processing_files[fullpath]) < DEBOUNCE_MS then
                return
            end
            processing_files[fullpath] = current_time
            local bufnr = vim.fn.bufnr(fullpath)
            if bufnr > 0 then
                vim.cmd(":e!")
                vim.notify(relate_path .. " changed from external", vim.log.levels.INFO)
            else
            end
        end)
    end)

    handles[fullpath] = handle
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = watch_file,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        vim.defer_fn(function()
            watch_file()
        end, 100)
    end,
})

vim.api.nvim_create_autocmd("BufDelete", {
    pattern = "*",
    callback = function()
        local filename = vim.fn.expand("<afile>:p")
        if handles[filename] then
            handles[filename]:close()
            handles[filename] = nil
        end
        processing_files[filename] = nil
    end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    pattern = "*",
    callback = function()
        local fullpath = vim.fn.expand("%:p")
        processing_files[fullpath] = nil
        watch_file()
    end,
})

return M
