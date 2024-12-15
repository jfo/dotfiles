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
vim.o.termguicolors = true

vim.g.claude_api_key = os.getenv('CLAUDE_API_KEY') or ''
vim.g.mapleader = '\\'

vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', {noremap = true})
vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', {noremap = true})
vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', {noremap = true})
vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', {noremap = true})

-- do not jump to next match immediately
vim.keymap.set('n', '*', function()
    local word = vim.fn.expand('<cword>')
    vim.fn.setreg('/', '\\<' .. word .. '\\>')
    vim.opt.hlsearch = true
end, { silent = true })

-- LSP client/server setup
local lspconfig = require'lspconfig'
lspconfig.ts_ls.setup{}
lspconfig.zls.setup{}
lspconfig.ccls.setup{}
lspconfig.terraformls.setup{}

vim.diagnostic.config({
  float = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = false,
})

-- most treesitter highlighting looks pretty bad compared to the native. It's
-- way more efficient, but the themes don't function as intended with whatever
-- TS is providing as tokens. Everybody misunderstands this! Maybe it will be
-- fixed, for now stay enabled in general for less used stuff and keep disabled
-- in special cases.
--
-- Should learn more about motions and text objects wrt TS
require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  auto_install = true, -- requires treesitter-cli
  highlight = {
    enable = false,
    disable = { 'zig', 'lua', 'javascript' },
  },
}

-- https://github.com/neovim/neovim/issues/23526#issuecomment-1539580310
-- much faster than the plugin, nasty as hell though
local ns = vim.api.nvim_create_namespace('CurlineDiag')
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd('LspAttach',{
  callback = function(args)
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = args.buf,
      callback = function()
        pcall(vim.api.nvim_buf_clear_namespace,args.buf,ns, 0, -1)
        local hi = { 'Error', 'Warn','Info','Hint'}
        local curline = vim.api.nvim_win_get_cursor(0)[1]
        local diagnostics = vim.diagnostic.get(args.buf, {lnum =curline - 1})
        local virt_texts = { { (' '):rep(4) } }
        for _, diag in ipairs(diagnostics) do
          virt_texts[#virt_texts + 1] = {diag.message, 'Diagnostic'..hi[diag.severity]}
        end
        vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0,{
          virt_text = virt_texts,
          hl_mode = 'combine'
        })
      end
    })
  end
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

-- MacOS system mode aware color switch
local function is_macos()
  local handle = io.popen('uname')
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Darwin") ~= nil
  end
  return false
end

local function get_macos_appearance()
  if not is_macos() then
    return "light"
  end

  local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null')
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") and "dark" or "light"
  end
  return "light"
end

local appearance = get_macos_appearance()
if appearance == "dark" then
  vim.cmd('set background=dark')
else
  vim.cmd('set background=light')
end
