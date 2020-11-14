local api = vim.api
local themes = require('themes')

local M = {}

local _default_theme

local _themes = {}

function M.set_popup_bufnr(bufnr)
  _themes[bufnr] = themes.popup
end

function M.set_default_theme(theme_ns)
  _default_theme = theme_ns
end

function M.setup()
  vim.o.background = 'light'
  _default_theme = themes.none
  local cb = function(bufnr)
    local theme = _themes[bufnr] or _default_theme
    api.nvim_set_hl_ns(theme)
  end
  local ns = api.nvim_create_namespace('fsouza.color')
  api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, bufnr)
      cb(bufnr)
    end;
    on_line = function(_, _, bufnr)
      cb(bufnr)
    end;
    on_buf = function(_, bufnr)
      cb(bufnr)
    end;
  })
end

return M
