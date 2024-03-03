-- DAP setup
local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
  print("nvim-dap not installed!")
  return
end

require('dap').set_log_level('DEBUG') -- Helps when configuring DAP, see logs with :DapShowLog

-- Mason setup
require("nvim-dap-virtual-text").setup()
require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb", "bash-debug-adapter", "debugpy"}
})

-- Setup adaptors
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

local pythonPath = '/opt/homebrew/bin/python3.10'
dap.adapters.python = {
  type = 'executable',
  command = pythonPath,
  args = { '-m', 'debugpy.adapter' },
}

dap.adapters.bashdb = {
  type = 'executable';
  command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
  name = 'bashdb';
}

dap.adapters["local-lua"] = {
  type = "executable",
  command = "node",
  args = {
    "/Users/Philip.Sjoberg/.local/share/nvim/site/pack/packer/start/local-lua-debugger-vscode/extension/debugAdapter.js"
  },
  enrich_config = function(config, on_config)
    if not config["extensionPath"] then
      local c = vim.deepcopy(config)
      c.extensionPath = "/Users/Philip.Sjoberg/.local/share/nvim/site/pack/packer/start/local-lua-debugger-vscode/"
      on_config(c)
    else
      on_config(config)
    end
  end,
}

-- Setup configurations

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      local args_str = vim.fn.input('Program arguments: ')
      return vim.split(args_str, " +")
    end,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch'; -- Specifies the debug request type
    name = "Launch File";
    program = "${file}"; -- Specifies the file to debug
    pythonPath = function()
      return pythonPath
    end;
    justMyCode = false; -- Ensures that only user code is debugged
  },
}

dap.configurations.sh = {
  {
    type = 'bashdb';
    request = 'launch';
    name = "Launch file";
    showDebugOutput = true;
    pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb';
    pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir';
    trace = true;
    file = "${file}";
    program = "${file}";
    cwd = '${workspaceFolder}';
    pathCat = "cat";
    pathBash = "/bin/bash";
    pathMkfifo = "mkfifo";
    pathPkill = "pkill";
    args = {};
    env = {};
    terminalKind = "integrated";
  }
}

dap.configurations.lua = {
  {
    name = 'Current file (local-lua-dbg, nlua)',
    type = 'local-lua',
    request = 'launch',
    cwd = '${workspaceFolder}',
    program = {
      lua = 'nlua', -- To allow vim debug
      -- lua = '/opt/homebrew/bin/lua', -- Basic lua debug
      file = '${file}',
    },
    verbose = true,
    args = {},
  },
}

-- Configure dapui
require("dapui").setup({
  expand_lines = false,
  icons = { expanded = "|", collapsed = ">", current_frame = "" },
  mappings = {
    expand = { "<C-j>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
        {
        elements = { {
            id = "breakpoints",
            size = 0.20
          }, {
            id = "scopes",
            size = 0.50
          }, {
            id = "repl",
            size = 0.30
          } },
          size = 0.25,
          position = "bottom",
        },
    },
controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "||",
      play = "▶",
      step_into = "↓",
      step_over = "→",
      step_out = "↑",
      step_back = "←",
      run_last = "↻",
      terminate = "✖",
      disconnect = "✖",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  }
})

-- Setup debugger for nvim lua
[[
Launch the server in the debuggee using `DapNvimDebugee`
Open another Neovim instance with the source file
Place breakpoint and start debugger with `DapNvimSource`
In the debuggee, call the specific function to debug
]]
vim.api.nvim_create_user_command('DapNvimDebugee', function()
    require("osv").launch({port = 8086})
end, {})

vim.api.nvim_create_user_command('DapNvimSource', function()
    dap.configurations.lua = {
      {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
      }
    }

    dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
    require("dap").continue()
end, {})




-- Setup start and stop

-- Setup event listener to start dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
    require("dapui").open({})
    vim.o.mouse = "a"
end

-- Setup close function for dapui
_G.Dapui_terminate = function()
    require("dap").terminate()
    require("dapui").close()
    require("dap").disconnect()
    vim.o.mouse = ""
end

