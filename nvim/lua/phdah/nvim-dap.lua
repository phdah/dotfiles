local snacks = require("snacks")

local M = {}

---------------
-- DAP setup --
---------------
local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
    snacks.notify.info("nvim-dap not installed!")
    return
end
local dv = require("dap-view")

-- Mason setup
require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })
require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb", "bash-debug-adapter", "debugpy", "delve" },
})

local function filtered_pick_process()
    local opts = {}
    vim.ui.input({
        prompt = "Search by process name (lua pattern), or hit enter to select from the process list: ",
    }, function(input)
        opts["filter"] = input or ""
    end)
    return require("dap.utils").pick_process(opts)
end

--------------------
-- Setup adaptors --
--------------------

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        -- CHANGE THIS to your path!
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
    },
}

dap.adapters["lldb-dap"] = {
    type = "server",
    port = "${port}",
    executable = {
        command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
        args = { "--port", "${port}" },
    },
}

local pythonPath = "python3"
dap.adapters.python = {
    type = "executable",
    command = pythonPath,
    args = { "-m", "debugpy.adapter" },
}

dap.adapters.bashdb = {
    type = "executable",
    command = vim.fn.stdpath("data")
        .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
    name = "bashdb",
}

dap.adapters["local-lua"] = {
    type = "executable",
    command = "node",
    args = {
        "/Users/Philip.Sjoberg/.local/share/nvim/lazy/local-lua-debugger-vscode/extension/debugAdapter.js",
    },
    enrich_config = function(config, on_config)
        if not config["extensionPath"] then
            local c = vim.deepcopy(config)
            c.extensionPath =
                "/Users/Philip.Sjoberg/.local/share/nvim/lazy/local-lua-debugger-vscode/"
            on_config(c)
        else
            on_config(config)
        end
    end,
}

dap.adapters.go = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    cwd = "${workspaceFolder}",
    executable = {
        command = "/Users/Philip.Sjoberg/.local/share/nvim/mason/bin/dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
        detached = true,
    },
    options = { initialize_timeout_sec = 20 },
}

--------------------------
-- Setup configurations --
--------------------------

-- Function to run dsymutil
local program
local function runDsymutil(executable)
    -- Determine the .dSYM path based on the executable name
    local dsymPath = executable .. ".dSYM"

    -- Check if the .dSYM directory exists
    local function dsymExists(path)
        local attr = vim.loop.fs_stat(path) -- Use luv (libuv) for file system checks
        return attr and attr.type == "directory"
    end

    if not dsymExists(dsymPath) then
        snacks.notify.info("No .dSYM exists on: " .. dsymPath)
        -- Run dsymutil if the .dSYM is missing
        local handle = io.popen("dsymutil " .. executable)
        if handle ~= nil then
            local result = handle:read("*a")
            handle:close()
        end
    else
    end
end

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "lldb-dap",
        request = "launch",
        program = function()
            program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            runDsymutil(program)
            return program
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
    {
        name = "Debug with Args",
        type = "lldb-dap",
        request = "launch",
        program = function()
            program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            runDsymutil(program)
            return program
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
            local args_str = vim.fn.input("Program arguments: ")
            return vim.split(args_str, " +")
        end,
    },
    {
        name = "Attach",
        type = "lldb-dap",
        request = "attach",
        pid = filtered_pick_process,
        stopOnEntry = false,
    },
    {
        name = "Attach to Name (wait)",
        type = "lldb-dap",
        stopOnEntry = false,
        request = "attach",
        program = function()
            program = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            runDsymutil(program)
            return program
        end,
        waitFor = true,
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.configurations.python = {
    {
        type = "python",
        request = "launch", -- Specifies the debug request type
        name = "Launch File",
        program = "${file}", -- Specifies the file to debug
        pythonPath = function()
            return pythonPath
        end,
        justMyCode = false, -- Ensures that only user code is debugged
    },
    {
        type = "python",
        request = "launch", -- Specifies the debug request type
        name = "Launch File With args",
        args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
        end,
        program = "${file}", -- Specifies the file to debug
        pythonPath = function()
            return pythonPath
        end,
        justMyCode = false, -- Ensures that only user code is debugged
    },
    {
        type = "python",
        request = "launch",
        name = "Launch pytest",
        module = "pytest",
        pythonPath = function()
            return pythonPath
        end,
        justMyCode = false,
    },
}

dap.configurations.sh = {
    {
        type = "bashdb",
        request = "launch",
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath("data")
            .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
        pathBashdbLib = vim.fn.stdpath("data")
            .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
        trace = true,
        file = "${file}",
        program = "${file}",
        cwd = "${workspaceFolder}",
        pathCat = "cat",
        pathBash = "/opt/homebrew/bin/bash",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        args = {},
        env = {},
        terminalKind = "integrated",
    },
}

dap.configurations.lua = {
    {
        name = "Current file (local-lua-dbg, nlua)",
        type = "local-lua",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = {
            lua = "nlua", -- To allow vim debug
            -- lua = '/opt/homebrew/bin/lua', -- Basic lua debug
            file = "${file}",
        },
        verbose = true,
        args = {},
    },
}

dap.configurations.vim = dap.configurations.lua

-- NOTE: The adapter is sourced in plugin/lsp.lua
dap.configurations.scala = {
    {
        type = "scala",
        request = "launch",
        name = "Run or Test File",
        metals = { runType = "runOrTestFile" },
    },
    {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = { runType = "testTarget" },
    },
}

dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
        buildFlags = "",
    },
    {
        type = "go",
        name = "Debug with Args",
        request = "launch",
        program = "${file}",
        args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
        end,
    },
    {
        type = "go",
        name = "Attach",
        mode = "local",
        request = "attach",
        processId = filtered_pick_process,
    },
    {
        name = "Attach to Name (wait)",
        type = "go",
        mode = "local",
        request = "attach",
        waitFor = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        stopOnEntry = true,
    },
    {
        type = "go",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}",
    },
    {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
    },
}
dap.configurations.java = {
    {
        name = "Debug Launch (2GB)",
        type = "java",
        request = "launch",
        vmArgs = "" .. "-Xmx2g ",
    },
    {
        name = "Debug Attach (8000)",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 8000,
    },
    {
        name = "Debug Attach (5005)",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 5005,
    },
}

------------------------
-- Configure dap view --
------------------------

dv.setup({
    winbar = {
        default_section = "repl",
    },
    windows = {
        height = 20,
        terminal = {
            hide = { "python", "go", "nlua" },
        },
    },
})

---------------------------------
-- Setup debugger for nvim lua --
---------------------------------

--[[
Launch the server in the debuggee using `DapNvimDebugee`
Open another Neovim instance with the source file
Place breakpoint and start debugger with `DapNvimSource`
In the debuggee, call the specific function to debug
]]
vim.api.nvim_create_user_command("DapNvimDebugee", function()
    require("osv").launch({ port = 8086 })
end, {})

vim.api.nvim_create_user_command("DapNvimSource", function()
    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
        },
    }

    dap.adapters.nlua = function(callback, config)
        callback({
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or 8086,
        })
    end
    require("dap").continue()
end, {})

M.send_code_to_repl = function()
    local code = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"))
    dap.repl.execute(table.concat(code, "\n"))
end

M.send_file_to_repl = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local code = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    dap.repl.execute(table.concat(code, "\n"))
end

local start_repl_session = function()
    snacks.notify.info("Starting REPL session")
    local filetype = vim.bo.filetype

    -- Start debugpy server in the background for the given filetype
    if filetype == "python" then
        vim.fn.jobstart(
            "PYDEVD_DISABLE_FILE_VALIDATION=1 "
                .. pythonPath
                .. " -Xfrozen_modules=off -m debugpy --listen 5678 -c 'import code; code.interact()'",
            {
                on_exit = function()
                    snacks.notify.info("debugpy exited")
                end,
                on_stdout = function()
                    snacks.notify.info("debugpy started")
                end,
            }
        )
        return true
    end
    snacks.notify.error("Error: No setup for " .. filetype .. " repl start")
    return false
end

-------------------------------
-- Setup REPL configurations --
-------------------------------

dap.adapters.python_repl = { type = "server", host = "127.0.0.1", port = 5678 }

local repl = {
    configurations = {
        ["python"] = {
            type = "python_repl",
            request = "attach",
            name = "Attach to running process",
            connect = { host = "127.0.0.1", port = dap.adapters.python_repl.port },
            pythonPath = function()
                M.repl_run = true
                return pythonPath
            end,
        },
    },
}

M.start_repl = function()
    local filetype = vim.bo.filetype
    local session_started = start_repl_session()
    if session_started then
        require("dap").run(repl.configurations[filetype])
    else
        snacks.notify.error("REPL session not started")
    end
end

--------------------------
-- Setup start and stop --
--------------------------

dap.listeners.before.attach["dap-view-config"] = function()
    dv.open()
end
dap.listeners.before.launch["dap-view-config"] = function()
    dv.open()
end

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "dap-float" },
    callback = function(evt)
        vim.keymap.set("n", "q", "<C-w>q", { silent = true, buffer = evt.buf })
    end,
})

return M
