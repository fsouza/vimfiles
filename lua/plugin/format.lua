local M = {}

local api = vim.api
local vfn = vim.fn

local format_stdin = function(format_cmd, format_args, timeout_ms)
  local bufnr = api.nvim_get_current_buf()
  local view = vfn.winsaveview()
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local cmd = require('lib/cmd')
  local block = cmd.run(format_cmd, {args = format_args}, table.concat(lines, '\n'), function(r)
    if r.exit_status ~= 0 then
      error(string.format('%s exited with status code %d: %s', format_cmd, r.exit_status, r.stderr))
    end

    local new_lines = vim.split(r.stdout, '\n')
    while new_lines[#new_lines] == '' do
      table.remove(new_lines, #new_lines)
    end

    local write = false
    for i, line in ipairs(new_lines) do
      if line ~= lines[i] then
        write = true
        break
      end
    end
    if write then
      api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    end
    vfn.winrestview(view)
  end)

  if timeout_ms then
    local status = block(timeout_ms)
    if not status then
      error(string.format('%s did not complete in %dms, consider increasing the timeout',
                          format_cmd, timeout_ms))
    end
  end
end

function M.lua(timeout_ms)
  format_stdin('lua-format', {}, timeout_ms)
end

return M
