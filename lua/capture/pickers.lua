local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local dropdown = require("telescope.themes").get_dropdown()

local M = {}

function M.title_entry_maker(entry)
    local filename, title = entry:match("([^,]+):([^,]+)")
    return {
        ordinal = filename,
        display = title,
    }
end

function M.tag_list_finder(path)
    return finders.new_oneshot_job({
        "rg",
        "--no-heading",
        "-NIow",
        "#[0-9A-Za-z_-]+",
        vim.fs.normalize(path),
    }, {})
end

function M.title_finder(path)
    return finders.new_oneshot_job({
        "rg",
        "--pre",
        "head",
        "--no-heading",
        "-NHox",
        "# .*",
        vim.fs.normalize(path),
    }, {
        entry_maker = function(entry)
            local filename, title = entry:match("([^,]+):([^,]+)")
            return {
                ordinal = filename,
                display = title,
            }
        end,
    })
end

function M.tag_finder(path, tag)
    return finders.new_oneshot_job({
        "rg",
        "--no-heading",
        "-NHow",
        tag,
        vim.fs.normalize(path),
    }, {
        entry_maker = function(entry)
            local filename, _ = entry:match("([^,]+):([^,]+)")
            local title = filename
            vim.print(title)
            local handle = io.popen("rg --no-heading -NIow '# .*' " .. filename)
            if handle then
                title = handle:read("*a")
                vim.print(title)
                handle:close()
            end
            return {
                ordinal = filename,
                display = title,
            }
        end,
    })
end

function M.grep_finder(path, word)
    return finders.new_oneshot_job({
        "rg",
        "--no-heading",
        "-NH",
        word,
        vim.fs.normalize(path),
    }, {})
end

-- local function enter(prompt_bufnr)
--     local selected = actions_state.get_selected_entry()
--     local cmd = "colorscheme " .. selected[1]
--     vim.cmd(cmd)
--     actions.close(prompt_bufnr)
-- end
--
-- attach_mappings = function(prompt_bufnr, map)
--     map("i", "<CR>", enter)
--     return true
-- end,
M.tag_list = function()
    local opts = {
        finder = M.tag_list_finder("~/projects/notes/"),
        sorter = sorters.get_generic_fuzzy_sorter(),
    }
    pickers.new(opts, dropdown):find()
end

M.find_note = function()
    local opts = {
        finder = M.title_finder("~/projects/notes/"),
        sorter = sorters.get_generic_fuzzy_sorter(),
    }
    pickers.new(opts, {}):find()
end

M.find_tag = function()
    local opts = {
        finder = M.tag_finder("~/projects/notes/", "#tag"),
        sorter = sorters.get_generic_fuzzy_sorter(),
    }
    pickers.new(opts, {}):find()
end

return M
