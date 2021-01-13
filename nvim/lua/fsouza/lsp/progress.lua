local vcmd = vim.cmd
local vfn = vim.fn
local lsp_util = vim.lsp.util
local helpers = require('fsouza.lib.nvim_helpers')

local M = {}

local echomsg = require('fsouza.lib.debounce').debounce(2000, vim.schedule_wrap(
                                                          function(msg)
    vcmd(string.format('echomsg %s', msg))
  end))

function M.on_progress_update()
  if vfn.mode() ~= 'n' then
    return
  end

  local messages = lsp_util.get_progress_messages()

  local function format_message(msg)
    local prefix = ''
    if msg.title ~= '' then
      prefix = string.format('%s: ', msg.title)
    end

    if msg.name ~= '' then
      prefix = string.format('[%s] %s', msg.name, prefix)
    end

    local suffix = ''
    if msg.percentage then
      suffix = string.format(' (%s)', msg.percentage)
    end

    return vfn.shellescape(string.format('%s%s%s', prefix, msg.message, suffix))
  end

  for _, message in ipairs(messages) do
    echomsg.call(format_message(message))
  end
end

function M.on_attach()
  helpers.augroup('fsouza__lsp_progress', {
    {
      events = {'User LspProgressUpdate'};
      command = [[lua require('fsouza.lsp.progress').on_progress_update()]];
    };
  })
end

return M
