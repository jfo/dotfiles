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
