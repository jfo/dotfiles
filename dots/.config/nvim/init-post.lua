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

require("ghostty-navigator").setup()

-- do not jump to next match immediately
vim.keymap.set('n', '*', function()
  local word = vim.fn.expand('<cword>')
  vim.fn.setreg('/', '\\<' .. word .. '\\>')
  vim.opt.hlsearch = true
end, { silent = true })

local util = require("lspconfig.util")
local root = util.root_pattern("rebar.config", ".git")(vim.fn.getcwd())
local build_lib = root .. "/_build/default/lib"
-- LSP client/server setup
vim.lsp.config('zls', {})
vim.lsp.config('ccls', {})
vim.lsp.config('terraformls', {})
vim.lsp.config('elp', {
    root_dir = root,
    cmd_env = {
      ERL_LIBS = build_lib,
    },
    settings = {
      elp = {
        diagnostics = {
          disabled = {
            "W0051"
          }
        }
      }
    }
  })
vim.lsp.enable({ 'zls', 'ccls', 'terraformls', 'elp' })

-- Suppress elp LSP attach messages
local orig_echo = vim.api.nvim_echo
vim.api.nvim_echo = function(chunks, ...)
  if chunks and chunks[1] and type(chunks[1][1]) == "string" and chunks[1][1]:match("LSP%[") then
    return
  end
  orig_echo(chunks, ...)
end

require("typescript-tools").setup{}

vim.diagnostic.config({
 virtual_text = { spacing = 1, prefix = ">", current_line = true },
 signs = true,
 underline = true,
 update_in_insert = false,
 severity_sort = true,
 float = {
   border = "rounded",
   source = "if_many",
   header = "",
   focusable = false,
   prefix = " ",
   scope = "cursor",
   max_width = 80,
   max_height = 12,
 },
})

vim.keymap.set("n", "gk", function()
  vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
end, { desc = "Diagnostics float" })

-- most treesitter highlighting looks pretty bad compared to the native. It's
-- way more efficient, but the themes don't function as intended with whatever
-- TS is providing as tokens. Everybody misunderstands this! Maybe it will be
-- fixed, for now stay enabled in general for less used stuff and keep disabled
-- in special cases. Sticking with vim-polyglot for now unless I see startup
-- time degradation.
--
-- That said, should be possible to get rid of most of the ugly with
-- customizing things a bit... but that will take some focus and A/B against
-- the standard grammars in polyglot f.ex
-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#highlight
local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if treesitter_ok then
  treesitter.setup {
    auto_install = true,
    highlight = {
      enable = false,
      -- languages specifically not highlighted:
      -- disable = {},
    },
    indent = {
      enable = true
    }
  }
end

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
