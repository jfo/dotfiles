set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
let mapleader = '\'

set clipboard^=unnamed         " yank and paste with the system clipboard
set cursorline                 " highlight the text line of the cursor with CursorLine |hl-CursorLine|.
set expandtab                  " expand tabs to spaces
set foldlevelstart=99           " start with all folds open
set foldmethod=indent
set foldnestmax=10
set ignorecase                 " case-insensitive search
set list                       " show trailing whitespace
set listchars=tab:\|\ ,trail:▫ " display whitespace with specified characters
set number                     " show line numbers by default
set nowrap
set nowrapscan                 " don't search from top if you hit the bottom
set ruler                      " show where you are
set scrolloff=5                " show context above/below cursorline
set shiftwidth=2               " normal mode indentation commands use 2 spaces
set smartcase                  " case-sensitive search if any caps
set smartindent
set softtabstop=2              " insert mode tab and backspace use 2 spaces
set tabstop=8                  " actual tabs occupy 8 characters
set wildmode=longest,list,full
set synmaxcol=240              " maximum column in which to search for syntax items, can otherwise choke on long lined files
set updatetime=1000            " wait one second after any typing to write swap file
set signcolumn=yes
set signcolumn=number

" do not jump to next match immediately
nmap <silent> * "syiw<Esc>: let @/ = @s<CR>

" quickly reload config
map <silent> <leader>V :source ~/.config/nvim/init.vim<CR>:filetype detect<CR>:exe ":echo 'init.vim reloaded'"<CR>

" clear highlighted text
nmap <leader>hl :let @/ = ""<CR>

" shift tab inputs real tabstop
inoremap <S-Tab> <C-V><Tab>

" leader w writes file
nnoremap <LEADER>w :w<CR>

" open/close quickfix list
nnoremap <LEADER>o :copen<cr>
nnoremap <LEADER>c :cclose<cr>

" open/close location list
nnoremap <LEADER>lo :lopen<cr>
nnoremap <LEADER>lc :lclose<cr>

" quickly put the full path of the current file in the system clipboard/unnamed register
nmap <LEADER>p :let @*=expand("%:p")<CR>

" Enable basic mouse behavior such as resizing buffers.
set mouse=a

" misc functions and mappings
function! StripTrailing()
  let previous_search=@/
  let previous_cursor_line=line('.')
  let previous_cursor_column=col('.')
  %s/\s\+$//e
  let @/=previous_search
  call cursor(previous_cursor_line, previous_cursor_column)
endfunction
nmap <leader><space> :call StripTrailing()<CR>

function! LineNumberToggle()
  if &number
    set nonumber
  else
    set number
  endif
endfunc
nnoremap gn :call LineNumberToggle()<CR>

function! ToggleTodo(...)
  if a:0
    let filename = '~/.todo'
  else
    let filename = '.todo'
  endif

  if expand('%:t') == '.todo'
    :w|bd
  else
    execute 'tab drop' filename
  endif
endfunction
nnoremap <LEADER>t :call ToggleTodo()<CR>
nnoremap <LEADER>T :call ToggleTodo('wat')<CR>

" PLUGINS
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'benjie/local-npm-bin.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jfo/vim-runners'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-node'
Plug 'neomake/neomake'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'prettier/vim-prettier'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'zig-lang/zig.vim'

" color schemes
Plug 'altercation/vim-colors-solarized'
Plug 'Mofiqul/vscode.nvim'
Plug 'plan9-for-vimspace/acme-colors'
call plug#end()

colorscheme solarized
set bg=light

nnoremap <F5> :colorscheme solarized<CR>:set background=light<CR>
nnoremap <F6> :colorscheme solarized<CR>:set background=dark<CR>
nnoremap <F7> :colorscheme vscode<CR>:set background=light<CR>
nnoremap <F8> :colorscheme vscode<CR>:set background=dark<CR>
nnoremap <F9> :colorscheme acme<CR>

nmap <F4> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><CR>-----------------------<CR><CR><Esc>

""" Plugin Specific Commands and mappings
let g:ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'
let g:NERDTreeWinSize = 50

" Ack!
nnoremap <leader>a :Ack!<space>
vnoremap <leader>a y:Ack! '<C-R>"'<CR>
" silver searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" vim-runners
nnoremap <LEADER>g :Run<CR>

" rhubarb
map <LEADER>x :GBrowse!<CR>
map <LEADER>X :GBrowse<CR>

" Nerdtree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
let g:NERDSpaceDelims=1

" Holy shit FZF
nmap <C-P> :Files<CR>
nmap <leader>b :Buffers<CR>
nmap gl :Lines<CR>

" commentary.vim comment strings
autocmd FileType sild set commentstring=;\ %s
autocmd FileType hex set commentstring=#\ %s

" https://github.com/christoomey/vim-tmux-navigator#configuration
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" neomake
let g:neomake_denolint_maker = {
    \ 'exe': 'deno',
    \ 'args': ['fmt', '--check'],
    \ }

let g:neomake_javascript_enabled_makers = ['denolint']
let g:neomake_logfile='/tmp/neomake_error.log'
call neomake#configure#automake('w')

function! FoldFunction()
  return getline(v:foldstart)
endfunction
setlocal fillchars=fold:┈
setlocal foldtext=FoldFunction()
hi Folded none

" typing λ
imap <C-l> <C-k>*l

" LSP client/server setup

lua <<EOF
local lspconfig = require'lspconfig'
lspconfig.denols.setup{}
lspconfig.zls.setup{}
lspconfig.ccls.setup{}

vim.diagnostic.config({
  virtual_text = false,
})
EOF

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

" save current session when exiting vim (useful for reloading state)
autocmd VimLeave * :mksession! ~/.vim/sessions/last.vim
