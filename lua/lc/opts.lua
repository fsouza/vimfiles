local M = {}

local api = vim.api

local attached = function(bufnr, client)
  local helpers = require('lib.nvim_helpers')
  vim.schedule(function()
    local mappings = {
      n = {
        {
          lhs = '<leader><leader>';
          rhs = helpers.cmd_map([[lua vim.lsp.diagnostic.show_line_diagnostics()]]);
          opts = {silent = true};
        };
        {
          lhs = '<leader>df';
          rhs = helpers.cmd_map([[lua require('lc.diagnostics').list_file_diagnostics()]]);
          opts = {silent = true};
        };
        {
          lhs = '<leader>dw';
          rhs = helpers.cmd_map([[lua require('lc.diagnostics').list_workspace_diagnostics()]]);
          opts = {silent = true};
        };
        {
          lhs = '<leader>cl';
          rhs = helpers.cmd_map([[lua require('lc.buf_diagnostic').buf_clear_all_diagnostics()]]);
          opts = {silent = true};
        };
        {
          lhs = '<c-n>';
          rhs = helpers.cmd_map([[lua vim.lsp.diagnostic.goto_next()]]);
          opts = {silent = true};
        };
        {
          lhs = '<c-p>';
          rhs = helpers.cmd_map([[lua vim.lsp.diagnostic.goto_prev()]]);
          opts = {silent = true};
        };
        {
          lhs = '<down>';
          rhs = helpers.cmd_map([[lua vim.lsp.diagnostic.goto_next()]]);
          opts = {silent = true};
        };
        {
          lhs = '<up>';
          rhs = helpers.cmd_map([[lua vim.lsp.diagnostic.goto_prev()]]);
          opts = {silent = true};
        };
      };
      i = {};
    }

    if client.resolved_capabilities.text_document_did_change then
      require('lc.shell_post').on_attach({bufnr = bufnr; client = client})
    end

    if client.resolved_capabilities.completion ~= nil and client.resolved_capabilities.completion ~=
      false then
      vim.cmd('packadd completion-nvim')
      require('completion').on_attach({
        trigger_on_delete = 1;
        auto_change_source = 1;
        confirm_key = [[\<C-y>]];
        matching_strategy_list = {'exact'; 'fuzzy'};
        chain_complete_list = {
          default = {
            {complete_items = {'lsp'}};
            {complete_items = {'buffers'}};
            {mode = {'<c-p>'}};
            {mode = {'<c-n>'}};
          };
        };
      })
      table.insert(mappings.i, {
        lhs = '<c-x><c-o>';
        rhs = 'v:lua.f.complete()';
        opts = {expr = true; silent = true};
      })
      table.insert(mappings.i,
                   {lhs = '<cr>'; rhs = 'v:lua.f.cr()'; opts = {expr = true; noremap = true}})
    end

    if client.resolved_capabilities.rename ~= nil and client.resolved_capabilities.rename ~= false then
      table.insert(mappings.n, {
        lhs = '<leader>r';
        rhs = helpers.cmd_map('lua vim.lsp.buf.rename()');
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.code_action then
      table.insert(mappings.n, {
        lhs = '<leader>cc';
        rhs = helpers.cmd_map([[lua require('lc.code_action').code_action()]]);
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.declaration then
      table.insert(mappings.n, {
        lhs = '<leader>gy';
        rhs = helpers.cmd_map('lua vim.lsp.buf.declaration()');
        opts = {silent = true};
      })
      table.insert(mappings.n, {
        lhs = '<leader>py';
        rhs = helpers.cmd_map([[lua require('lc.locations').preview_declaration()]]);
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.document_formatting then
      require('lc.formatting').register_client(client, bufnr)
    end

    table.insert(mappings.n, {
      lhs = '<leader>s';
      rhs = helpers.cmd_map('lua vim.lsp.buf.document_highlight()');
      opts = {silent = true};
    })
    table.insert(mappings.n, {
      lhs = '<leader>S';
      rhs = helpers.cmd_map('lua vim.lsp.buf.clear_references()');
      opts = {silent = true};
    })

    if client.resolved_capabilities.document_symbol then
      vim.g.vista_default_executive = 'nvim_lsp'
      table.insert(mappings.n, {
        lhs = '<leader>t';
        rhs = helpers.cmd_map('lua vim.lsp.buf.document_symbol()');
        opts = {silent = true};
      })
      table.insert(mappings.n,
                   {lhs = '<leader>v'; rhs = helpers.cmd_map('Vista!!'); opts = {silent = true}})
    end

    if client.resolved_capabilities.find_references then
      table.insert(mappings.n, {
        lhs = '<leader>q';
        rhs = helpers.cmd_map('lua vim.lsp.buf.references()');
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.goto_definition then
      table.insert(mappings.n, {
        lhs = '<leader>gd';
        rhs = helpers.cmd_map('lua vim.lsp.buf.definition()');
        opts = {silent = true};
      })
      table.insert(mappings.n, {
        lhs = '<leader>pd';
        rhs = helpers.cmd_map([[lua require('lc.locations').preview_definition()]]);
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.hover then
      table.insert(mappings.n, {
        lhs = '<leader>i';
        rhs = helpers.cmd_map('lua vim.lsp.buf.hover()');
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.implementation then
      table.insert(mappings.n, {
        lhs = '<leader>gi';
        rhs = helpers.cmd_map('lua vim.lsp.buf.implementation()');
        opts = {silent = true};
      })
      table.insert(mappings.n, {
        lhs = '<leader>pi';
        rhs = helpers.cmd_map([[lua require('lc.locations').preview_implementation()]]);
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.signature_help then
      table.insert(mappings.n, {
        lhs = '<c-k>';
        rhs = helpers.cmd_map('lua vim.lsp.buf.signature_help()');
        opts = {silent = true};
      })
      table.insert(mappings.i, {
        lhs = '<c-k>';
        rhs = helpers.cmd_map('lua vim.lsp.buf.signature_help()');
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.type_definition then
      table.insert(mappings.n, {
        lhs = '<leader>gt';
        rhs = helpers.cmd_map('lua vim.lsp.buf.type_definition()');
        opts = {silent = true};
      })
      table.insert(mappings.n, {
        lhs = '<leader>pt';
        rhs = helpers.cmd_map([[lua require('lc.locations').preview_type_definition()]]);
        opts = {silent = true};
      })
    end

    if client.resolved_capabilities.workspace_symbol then
      table.insert(mappings.n, {
        lhs = '<leader>T';
        rhs = helpers.cmd_map('lua vim.lsp.buf.workspace_symbol()');
        opts = {silent = true};
      })
    end

    -- should use resolved_capabilities here, but this is not supported by nvim
    -- yet.
    if client.server_capabilities.codeLensProvider then
      require('lc.code_lens').on_attach({
        bufnr = bufnr;
        client = client;
        mapping = '<leader><cr>';
        can_resolve = client.server_capabilities.codeLensProvider.resolveProvider == true;
        supports_command = client.resolved_capabilities.execute_command;
      })
    end

    if client.resolved_capabilities.execute_command then
      require('lc.commands').on_attach({bufnr = bufnr; client = client})
    end

    vim.schedule(function()
      helpers.create_mappings(mappings, bufnr)
    end)
  end)
end

local on_attach = function(client, bufnr)
  local all_clients = vim.lsp.get_active_clients()
  for _, c in pairs(all_clients) do
    if c.id == client.id then
      client = c
    end
  end

  if bufnr == 0 or bufnr == nil then
    bufnr = api.nvim_get_current_buf()
  end

  attached(bufnr, client)
end

function M.with_default_opts(opts)
  return vim.tbl_extend('keep', opts, {
    callbacks = require('lc.callbacks');
    on_attach = on_attach;
    capabilities = vim.tbl_deep_extend('keep', opts.capabilities or {}, {
      textDocument = {completion = {completionItem = {snippetSupport = false}}};
    }, require('vim.lsp.protocol').make_client_capabilities());
  });
end

M.project_root_pattern = function()
  return require('nvim_lsp').util.root_pattern('.git')
end

M.cwd_root_pattern = function()
  return vim.loop.cwd()
end

return M
