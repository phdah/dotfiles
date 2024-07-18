local actions = require("telescope.actions")
require("telescope").setup({
    path_display = {filename_first = {reverse_directories = false}},
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
                ["<C-k>"] = {"<esc>", type = "command"},
                ["<C-j>"] = actions.select_default
            },
            n = {
                ["q"] = actions.close,
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
                ["<C-j>"] = actions.select_default
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
})

-- Load fzf-native search
require('telescope').load_extension('fzf')

-- Setup dynamic git root file finder
local M = {}
M.find_files_git = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        require("telescope").extensions.smart_open.smart_open()
        -- require('telescope.builtin').find_files()
    else
        require("telescope").extensions.smart_open.smart_open({cwd = root})
        -- require('telescope.builtin').find_files({cwd = root})
    end
end

M.live_grep_git = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        require('telescope.builtin').live_grep()
    else
        require('telescope.builtin').live_grep({cwd = root})
    end
end

M.grep_string_git = function()
    -- If git repo, show all files in repo.
    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    if root ==
        'fatal: not a git repository (or any of the parent directories): .git' then
        require('telescope.builtin').grep_string()
    else
        require('telescope.builtin').grep_string({cwd = root})
    end
end

-- Diffs

--- Run a shell command and return the output
--- @param cmd table The command to run in the format { "command", "arg1", "arg2", ... }
--- @param cwd? string The current working directory
--- @return table stdout, number? return_code, table? stderr
function M.get_cmd_output(cmd, cwd)
    if type(cmd) ~= "table" then
        vim.notify("Command must be a table", 3, {title = "Error"})
        return {}
    end

    local command = table.remove(cmd, 1)
    local stderr = {}
    local stdout, ret = require("plenary.job"):new({
        command = command,
        args = cmd,
        cwd = cwd,
        on_stderr = function(_, data) table.insert(stderr, data) end
    }):sync()

    return stdout, ret, stderr
end

--- Write a table of lines to a file
--- @param file string Path to the file
--- @param lines table Table of lines to write to the file
function M.write_to_file(file, lines)
    if not lines or #lines == 0 then return end
    local buf = io.open(file, "w")
    for _, line in ipairs(lines) do
        if buf ~= nil then buf:write(line .. "\n") end
    end

    if buf ~= nil then buf:close() end
end

--- Display a diff between the current buffer and a given file
--- @param file string The file to diff against the current buffer
function M.diff_file(file)
    local pos = vim.fn.getpos(".")
    local current_file = vim.fn.expand("%:p")
    vim.cmd("edit " .. file)
    vim.cmd("vert diffsplit " .. current_file)
    vim.fn.setpos(".", pos)
end

--- Display a diff between a file at a given commit and the current buffer
--- @param commit string The commit hash
--- @param file_path string The file path
function M.diff_file_from_history(commit, file_path)
    local extension = vim.fn.fnamemodify(file_path, ":e") == "" and "" or "." ..
                          vim.fn.fnamemodify(file_path, ":e")
    local temp_file_path = os.tmpname() .. extension

    local root = vim.fn.trim(vim.fn.system('git rev-parse --show-toplevel'))
    local cmd = {"git", "show", commit .. ":" .. file_path:gsub(root .. "/", "")}
    local out = M.get_cmd_output(cmd)

    M.write_to_file(temp_file_path, out)
    M.diff_file(temp_file_path)
end

local previewers = require('telescope.previewers')
local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    return { 'git', 'diff', entry.value .. '^!', '--', entry.current_file }
  end
}

--- Open a telescope picker to select a commit to diff against the current buffer
function M.telescope_diff_from_history()
    local current_file = vim.fn.expand("%:p")
    require("telescope.builtin").git_commits({
        git_command = {
            "git", "log", "--pretty=oneline", "--abbrev-commit", "--follow",
            "--", current_file
        },
        previewer = {delta},
        attach_mappings = function(prompt_bufnr)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                M.diff_file_from_history(selection.value, current_file)
            end)
            return true
        end
    })
end

return M
