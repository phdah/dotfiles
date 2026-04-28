local github_default = require("blink-cmp-git.default.github")
local commit_default = require("blink-cmp-git.default.commit")

local function make_get_command_args(default_fn)
    return function(command, token)
        local args = default_fn(command, token)
        vim.list_extend(args, { "--hostname", require("octo.utils").get_remote_host() })
        return args
    end
end

return {
    module = "blink-cmp-git",
    name = "Git",
    opts = {
        commit = {
            get_command_args = make_get_command_args(commit_default.get_command_args),
        },
        git_centers = {
            github = {
                issue = {
                    get_command_args = make_get_command_args(
                        github_default.issue.get_command_args
                    ),
                },
                pull_request = {
                    get_command_args = make_get_command_args(
                        github_default.pull_request.get_command_args
                    ),
                },
                mention = {
                    get_command_args = make_get_command_args(
                        github_default.mention.get_command_args
                    ),
                    get_documentation = function(item)
                        local doc = github_default.mention.get_documentation(item)
                        doc.get_command_args = make_get_command_args(doc.get_command_args)
                        return doc
                    end,
                },
            },
        },
    },
}
