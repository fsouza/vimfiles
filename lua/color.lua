local nvim_command = vim.api.nvim_command
local nvim_set_option = vim.api.nvim_set_option

local keys = {'cterm'; 'ctermbg'; 'ctermfg'; 'gui'; 'guibg'; 'guifg'}

local highlight = function(group, opts)
  local cmd_args = {group}
  for _, k in pairs(keys) do
    table.insert(cmd_args, string.format('%s=%s', k, opts[k] or 'NONE'))
  end
  nvim_command('highlight ' .. table.concat(cmd_args, ' '))
end

local basics = function()
  highlight('CursorLine', {ctermbg = '253'; guibg = '#dadada'})
  highlight('CursorLineNr', {cterm = 'bold'; ctermbg = '253'; gui = 'bold'; guibg = '#dadada'})
  highlight('Directory', {ctermfg = '59'; guifg = '#5f5f5f'})
  highlight('LineNr', {ctermbg = '253'; guibg = '#dadada'})
  highlight('MatchParen', {ctermbg = '145'; guibg = '#afafaf'})
  highlight('Normal', {ctermfg = '235'; guifg = '#262626'})
  highlight('Floating', {ctermfg = '235'; guibg = '#fcfcfc'; guifg = '#262626'})
  highlight('Pmenu', {ctermbg = '145'; guibg = '#afafaf'})
  highlight('SignColumn', {ctermbg = '253'; ctermfg = '232'; guibg = '#dadada'; guifg = '#080808'})
  highlight('SpecialKey', {ctermfg = '59'; guifg = '#5f5f5f'})
  highlight('SpellBad', {ctermfg = '196'; guifg = '#ff0000'})
  highlight('TabLine', {ctermbg = '145'; ctermfg = '59'; guibg = '#afafaf'; guifg = '#5f5f5f'})
  highlight('TabLineFill', {ctermbg = '145'; guibg = '#afafaf'})
  highlight('TabLineSel', {ctermfg = '59'; guifg = '#5f5f5f'})
  highlight('Title', {})
  highlight('ModeMsg', {})
  highlight('ErrorMsg', {ctermbg = '160'; ctermfg = '231'; guibg = '#d70000'; guifg = '#ffffff'})
  highlight('WarningMsg', {cterm = 'None'; ctermfg = '52'; guifg = '#5f0000'})
end

local noners = function()
  local noners = {
    'Boolean'; 'Character'; 'Comment'; 'Conceal'; 'Conditional'; 'Constant'; 'Debug'; 'Define';
    'Delimiter'; 'Error'; 'Exception'; 'Float'; 'Function'; 'Identifier'; 'Ignore'; 'Include';
    'Keyword'; 'Label'; 'Macro'; 'NonText'; 'Number'; 'Operator'; 'PmenuSbar'; 'PmenuSel';
    'PmenuThumb'; 'Question'; 'Search'; 'PreCondit'; 'PreProc'; 'Repeat'; 'Special'; 'SpecialChar';
    'SpecialComment'; 'Statement'; 'StorageClass'; 'String'; 'Structure'; 'Tag'; 'Todo'; 'Type';
    'Typedef'; 'Underlined'; 'htmlBold';
  }
  for _, group in pairs(noners) do
    highlight(group, {})
  end
end

local reversers = function()
  local reversers = {'MoreMsg'; 'StatusLine'; 'StatusLineNC'; 'Visual'};
  for _, group in pairs(reversers) do
    highlight(group, {cterm = 'reverse'; gui = 'reverse'})
  end
end

local lsp_highlights = function()
  local diagnostics = {guifg = '#a8a8a8'; ctermfg = '248'}
  local diagnostics_sign = {guifg = '#262626'; ctermfg = '235'; guibg = '#dadada'; ctermbg = '253'}

  for _, level in pairs({'Error'; 'Warning'; 'Information'; 'Hint'}) do
    local base_group = 'LspDiagnostics' .. level
    local sign_group = base_group .. 'Sign'
    highlight(base_group, diagnostics)
    highlight(sign_group, diagnostics_sign)
  end

  local reference = {guibg = '#d0d0d0'; ctermbg = '252'}
  for _, ref_type in pairs({'Text'; 'Read'; 'Write'}) do
    highlight('LspReference' .. ref_type, reference)
  end
end

local custom_groups = function()
  highlight('HlYank', {ctermbg = '225'; guibg = '#ffd7ff'})
  highlight('BadWhitespace', {ctermbg = '160'; guibg = '#d70000'})
end

local setup = function()
  nvim_set_option('background', 'light')
  nvim_command('highlight clear')
  nvim_command('syntax reset')
  vim.g.colors_name = 'none'

  basics()
  noners()
  reversers()
  lsp_highlights()
  custom_groups()

  vim.schedule(function()
    nvim_command([[command! ResetColors lua require('color').setup()]])
  end)
end

return {setup = setup}