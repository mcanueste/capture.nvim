local ui = require("capture.ui")

local M = {}

function M.note_path(path, id)
    return vim.fs.normalize(path) .. "/" .. id .. ".md"
end

function M.day_id()
    return os.date("%Y-%m-%d")
end

function M.uid()
    return os.date("%Y%m%d%H%M%S")
end

function M.open_note(path, id)
    vim.cmd.edit(M.note_path(path, id))
end

function M.insert_title(title)
    local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
    if #lines > 1 and not lines[1] == "" then
        return
    end
    vim.api.nvim_set_current_line(title)
end

function M.open_and_insert_title(path, note_id)
    ui.popup()
    M.open_note(path, note_id)
    M.insert_title("# " .. note_id)
end

function M.capture(path)
    M.open_and_insert_title(path, "# " .. M.uid())
end

function M.daily(path)
    M.open_and_insert_title(path, "# " .. M.day_id())
end

return M
