vim.g.mapleader = '\\'

-- Set various options
vim.o.clipboard = 'unnamed'
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.ignorecase = true
vim.o.list = true
vim.o.listchars = 'tab:| ,trail:▫'
vim.o.number = true
vim.o.wrap = false
vim.o.wrapscan = false
vim.o.ruler = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 8
vim.o.wildmode = 'longest,list,full'
vim.o.synmaxcol = 240
vim.o.updatetime = 1000
vim.o.signcolumn = 'yes'
vim.o.mouse = 'a'

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
