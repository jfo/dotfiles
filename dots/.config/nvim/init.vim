set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

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
inoremap jj <esc>
inoremap <c-c> <esc>

tnoremap jj <C-\><C-n>
tnoremap <esc> <C-\><C-n>
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
Plug 'christoomey/vim-tmux-navigator'
Plug 'jfo/vim-runners'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'moll/vim-node'
Plug 'neomake/neomake'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pasky/claude.vim'
Plug 'prettier/vim-prettier'
" consider [oil](https://github.com/stevearc/oil.nvim) as a replacement for
" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'

" color schemes
Plug 'Mofiqul/vscode.nvim'
Plug 'morhetz/gruvbox'
Plug 'nordtheme/vim'
Plug 'overcache/NeoSolarized'
Plug 'plan9-for-vimspace/acme-colors'
call plug#end()

nnoremap <F5> :colorscheme NeoSolarized<CR>
nnoremap <F6> :colorscheme nord<CR>
nnoremap <F7> :colorscheme gruvbox<CR>
nnoremap <F8> :colorscheme vscode<CR>
nnoremap <F9> :let &background = &background == 'light' ? 'dark' : 'light'<CR>
colorscheme gruvbox

nmap <F4> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><CR>-----------------------<CR><CR><Esc>

""" Plugin Specific Commands and mappings
"let g:ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'
let g:NERDTreeWinSize = 30

" Ack!
nnoremap <leader>a :Ack!<space>
vnoremap <leader>a y:Ack! '<C-R>"'<CR>
" silver searcher
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
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
autocmd FileType c setlocal commentstring=\/\/\ %s

au BufRead,BufNewFile *.sld set filetype=scheme

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

" save current session when exiting vim (useful for reloading state)
autocmd VimLeave * :mksession! ~/.vim/sessions/last.vim

luafile ~/.config/nvim/init-post.lua
