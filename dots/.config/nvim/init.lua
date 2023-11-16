-- LSP client/server setup
local lspconfig = require'lspconfig'
-- lspconfig.denols.setup{}
lspconfig.tsserver.setup{}
lspconfig.zls.setup{}
lspconfig.ccls.setup{}
lspconfig.solargraph.setup{}

vim.diagnostic.config({
  virtual_text = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
  end,
});

-- LSP keybindings
local mappings = {
  ['<c-]>'] = vim.lsp.buf.definition,
  ['K'] = vim.lsp.buf.hover,
  ['gD'] = vim.lsp.buf.implementation,
  -- ['<c-k>'] = vim.lsp.buf.signature_help,
  ['1gD'] = vim.lsp.buf.type_definition,
  ['gr'] = vim.lsp.buf.references,
  ['g0'] = vim.lsp.buf.document_symbol,
  ['gW'] = vim.lsp.buf.workspace_symbol,
  ['gd'] = vim.lsp.buf.declaration,
}

for key, action in pairs(mappings) do
  vim.keymap.set('n', key, action, { silent = true })
end
