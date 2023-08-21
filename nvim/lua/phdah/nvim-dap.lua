local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
  print("nvim-dap not installed!")
  return
end

require('dap').set_log_level('DEBUG') -- Helps when configuring DAP, see logs with :DapShowLog

-- Mason setup
require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb", "bash-debug-adapter" }
})

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
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


-- Configure dap-python
require('dap-python').setup('/usr/bin/python3')

-- Configure dap bash
dap.adapters.bashdb = {
  type = 'executable';
  command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
  name = 'bashdb';
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

-- Configure dap lua
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server',
    host = config.host or "127.0.0.1",
    port = config.port or 8086
})
end

_G.MyDapContinue = function()
  local ft = vim.bo.filetype  -- Get current file type
  if ft == "lua" then
    require"osv".run_this()
  else
    require"dap".continue()
  end
end

-- Configure dapui
require("dapui").setup({
  icons = { expanded = "|", collapsed = ">", current_frame = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<C-j>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.4 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
  },
  -- controls = {
  --   enabled = true,
  --   element = "repl",
  --   icons = {
  --     pause = "",
  --     play = "",
  --     step_into = "",
  --     step_over = "",
  --     step_out = "",
  --     step_back = "",
  --     run_last = "",
  --     terminate = "",
  --   },
  -- },
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

-- Save your custom status line
local custom_statusline = vim.o.statusline

-- Function to set the status line to only display the file type
local function set_dap_statusline()
    vim.o.statusline = '%y'
end

-- Function to restore your custom status line
local function restore_statusline()
    vim.o.statusline = custom_statusline
end

-- Setup event listener to start dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
    require("dapui").open({})
    set_dap_statusline()
end

-- Setup close function for dapui
_G.Dapui_terminate = function()
    require("dap").terminate()
    require("dapui").close()
    restore_statusline()
end

