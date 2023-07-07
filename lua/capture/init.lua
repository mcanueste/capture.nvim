local fterm = require("FTerm")

local M = {
    cmd = "nvim",
    notes_dir = "~/projects/notes/capture/",
    height = 0.9,
    width = 0.7,
}

function M.date()
    return os.date("%Y-%m-%d")
end

function M.timestamp()
    return os.date("%H:%M:%S")
end

function M.note_path(note_id)
    return vim.fs.normalize(M.notes_dir .. "/" .. note_id .. ".md")
end

function M.buf_str()
    local buf_path = vim.fn.expand("%:p")
    local buf_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    if buf_path == "" then
        return "scratch"
    end
    return buf_path .. ":" .. buf_row
end

function M.exec_str()
    local buf_str = M.buf_str()
    return ':exe "normal G2go\\<esc>Gi**' .. M.timestamp() .. " - " .. buf_str .. '**\\<esc>"'
end

function M.cmd_str()
    local note_path = M.note_path(M.date())
    local exec_str = M.exec_str()
    return M.cmd .. " -c '" .. exec_str .. "' " .. note_path
end

function M.capture()
    fterm
        :new({
            ft = "fterm_capture",
            cmd = M.cmd_str(),
            dimensions = {
                height = M.height,
                width = M.width,
            },
        })
        :open()
end

return M
