local U = {}

---@class Dimensions - Every field inside the dimensions should be b/w `0` to `1`
---@field height number: Height of the floating window (default: `0.8`)
---@field width number: Width of the floating window (default: `0.8`)
---@field x number: X-Axis of the floating window (default: `0.5`)
---@field y number: Y-Axis of the floating window (default: `0.5`)

---@class Config
---@field ft string: Filetype of the terminal buffer (default: `FTerm`)
---@field border string: Border type for the floating window. See `:h nvim_open_win` (default: `single`)
---@field hl string: Highlight group for the terminal buffer (default: `true`)
---@field blend number: Transparency of the floating window (default: `true`)
---@field env table: Map of environment variables extending the current environment (default: `nil`)
---@field dimensions Dimensions: Dimensions of the floating window

---@type Config
U.defaults = {
    ft = "markdown",
    border = "single",
    hl = "Normal",
    blend = 0,
    dimensions = {
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,
    },
}

---Create terminal dimension relative to the viewport
---@param opts Dimensions
---@return table
function U.get_dimension(opts)
    -- get lines and columns
    local cl = vim.o.columns
    local ln = vim.o.lines

    -- calculate our floating window size
    local width = math.ceil(cl * opts.width)
    local height = math.ceil(ln * opts.height - 4)

    -- and its starting position
    local col = math.ceil((cl - width) * opts.x)
    local row = math.ceil((ln - height) * opts.y - 1)

    return {
        width = width,
        height = height,
        col = col,
        row = row,
    }
end

---Check whether the window is valid
---@param win number Window ID
---@return boolean
function U.is_win_valid(win)
    return win and vim.api.nvim_win_is_valid(win)
end

---Check whether the buffer is valid
---@param buf number Buffer ID
---@return boolean
function U.is_buf_valid(buf)
    return buf and vim.api.nvim_buf_is_loaded(buf)
end

function U.popup()
    -- create buffer
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

    -- create window
    local cfg = U.defaults
    local dim = U.get_dimension(cfg.dimensions)
    local win = vim.api.nvim_open_win(buf, true, {
        border = cfg.border,
        relative = "editor",
        style = "minimal",
        width = dim.width,
        height = dim.height,
        col = dim.col,
        row = dim.row,
    })
    vim.api.nvim_win_set_option(win, "winhl", ("Normal:%s"):format(cfg.hl))
    vim.api.nvim_win_set_option(win, "winblend", cfg.blend)
end

return U
