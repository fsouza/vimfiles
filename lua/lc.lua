local M = {}

local function on_attach(client, _)
  local all_clients = vim.lsp.get_active_clients()
  for _, c in pairs(all_clients) do
    if c.name == client.name then
      client = c
    end
  end

  local enable_autoformat = client.resolved_capabilities.document_formatting
  vim.api.nvim_call_function("fsouza#lc#LC_attached", { enable_autoformat })
end

function M.setup()
  local lsp = require("nvim_lsp")

  lsp.bashls.setup({
    cmd = { "vim-nodels", "bash-language-server", "start" };
  })

  lsp.cssls.setup({
    cmd = { "vim-nodels", "css-laguageserver", "--stdio" };
  })

  lsp.gopls.setup({
    init_options = {
      deepCompletion = false;
      staticcheck = true;
      analyses = {
        unusedparams = true;
        ST1000 = false;
      };
    };
  })

  lsp.html.setup({
    cmd = { "vim-nodels", "html-langserver", "--stdio" };
  })

  lsp.jsonls.setup({
    cmd = { "vim-nodels", "vscode-json-languageserver", "--stdio" };
  })

  lsp.ocamllsp.setup({
    cmd = { "vim-ocaml-lsp" };
  })

  lsp.pyls.setup({
    cmd = { "python", "-m", "pyls" };
    settings = {
      pyls = {
        plugins = {
          jedi_completion = {
            enabled = true;
            fuzzy = true;
            include_params = false;
          };
        };
      };
    };
    on_attach = on_attach;
  })

  lsp.rust_analyzer.setup({})

  lsp.tsserver.setup({
    cmd = { "vim-nodels", "typescript-language-server", "--stdio" };
  })

  lsp.vimls.setup({
    cmd = { "vim-nodels",  "vim-language-server", "--stdio" };
    on_attach = on_attach;
  })

  lsp.yamlls.setup({
    cmd = { "vim-nodels", "yaml-language-server", "--stdio" };
  })
end

-- TODO: nvim-lsp will eventually support this, so once the pending PR is
-- merged, we should delete this code.
local function formatting_params(options)
  local sts = vim.bo.softtabstop
  options = vim.tbl_extend("keep", options or {}, {
    tabSize = (sts > 0 and sts) or (sts < 0 and vim.bo.shiftwidth) or vim.bo.tabstop;
    insertSpaces = vim.bo.expandtab;
  })
  return {
    textDocument = { uri = vim.uri_from_bufnr(0) };
    options = options;
  }
end

function M.formatting_sync(options, timeout_ms)
  local params = formatting_params(options)
  local result = vim.lsp.buf_request_sync(0, "textDocument/formatting", params, timeout_ms)
  if not result then return end
  result = result[1].result
  vim.lsp.util.apply_text_edits(result)
end

function M.nvim_lsp_enabled_for_current_ft()
  local clients = vim.lsp.buf_get_clients()
  local length = 0
  for _ in pairs(clients) do
    length = length + 1
  end
  return length > 0
end

return M
