-- Status line 

_G.nvim_GitBranch = function()
  return vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
end

_G.nvim_StatuslineGit = function()
  local branchname = _G.nvim_GitBranch()
  return #branchname > 0 and ' Branch: ' .. branchname .. ' ' or ''
end

_G.nvim_GitStatus = function()
  local a, m, r = unpack(vim.fn.GitGutterGetHunkSummary())
  return string.format(' | +%d ~%d -%d ', a, m, r)
end

_G.nvim_Cbuffer_number = function(number)
  local buffer = vim.fn.getbufinfo({bufloaded = 1})[number].bufnr
  return buffer
end

_G.nvim_Buffer_lower = function()
  local bufferinfo = vim.fn.getbufinfo({bufloaded = 1})
  local current_buffer = vim.fn.bufnr('%')
  local lower_bound = {}

  local i = 1
  while bufferinfo[i].bufnr < current_buffer do
    table.insert(lower_bound, i)
    i = i + 1
  end

  return #lower_bound == 0 and '' or ('[' .. table.concat(lower_bound, ", ") .. ']')
end

_G.nvim_Buffer_upper = function()
  local bufferinfo = vim.fn.getbufinfo({bufloaded = 1})
  local current_buffer = vim.fn.bufnr('%')
  local i = 1

  while bufferinfo[i].bufnr ~= current_buffer do
    i = i + 1
  end

  local upper_bound = {}
  for j = i+1, #bufferinfo do
    table.insert(upper_bound, j)
  end

  return #upper_bound == 0 and '' or ('[' .. table.concat(upper_bound, ", ") .. ']')
end

_G.nvim_Buffer_current = function()
  local bufferinfo = vim.fn.getbufinfo({bufloaded = 1})
  local current_buffer = vim.fn.bufnr('%')
  local i = 1

  while bufferinfo[i].bufnr ~= current_buffer do
    i = i + 1
  end

  return tostring(i)
end

-- Git and path/file name
vim.o.statusline = '%#CursorColumn#%{v:lua.nvim_StatuslineGit()}%{v:lua.nvim_GitStatus()}%#LineNr#'
vim.o.statusline = vim.o.statusline .. ' %f%m'
-- Buffers
vim.o.statusline = vim.o.statusline .. '%='
vim.o.statusline = vim.o.statusline .. '%{v:lua.nvim_Buffer_lower()}%#CursorColumn#[ %{v:lua.nvim_Buffer_current()} ]%#LineNr#%{v:lua.nvim_Buffer_upper()}'
-- File format and lines
vim.o.statusline = vim.o.statusline .. '%='
vim.o.statusline = vim.o.statusline .. '%#CursorColumn# %y %{&fileencoding?&fileencoding:&encoding}[%{&fileformat}] %p%% %l:%c'

