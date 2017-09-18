set nocompatible
syntax enable
filetype plugin indent on
let mapleader = '\'

set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set smartcase                                                " case-sensitive search if any caps
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set nonumber                                                 " don't show line numbers by default
set ruler                                                    " show where you are
set scrolloff=5                                              " show context above/below cursorline
set shiftwidth=4                                             " normal mode indentation commands use 4 spaces
set softtabstop=4                                            " insert mode tab and backspace use 4 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set showcmd
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set nowrapscan                                               " don't search from top if you hit the bottom
set smartindent
set autoindent
set hlsearch
set foldmethod=indent
set foldnestmax=2
set foldlevelstart=20
set splitbelow
set splitright

autocmd VimResized * :wincmd =

highlight LineNr ctermfg=blue
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nmap <leader>hl :let @/ = ""<CR>

" leader w forever
nnoremap <LEADER>w :w<CR>

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX') && !has('nvim')
    set ttymouse=xterm2
endif


""" Plugin Specific Commands
" Hound
" nnoremap <leader>a :HoundQF<space>
" vnoremap <leader>a y:HoundQF<space><C-R>"<CR>
" let g:hound_base_url = "hound.jfo.click"
" let g:hound_repos = "repo1, rep2"
" let g:hound_repo_paths = {
"             \"repo1": "~/repo1/path",
"             \"repo2": "~/repo2/path", }

" vim-runners!
nnoremap <LEADER>g :Run<CR>

" Nerdtree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
let g:NERDSpaceDelims=1

" Holy shit FZF
nmap <C-P> :Files<CR>
nmap <leader>b :Buffers<CR>

" commentary.vim comment strings
autocmd FileType sild set commentstring=;\ %s
autocmd FileType clojure set commentstring=;\ %s
autocmd FileType asm set commentstring=//\ %s
autocmd FileType vm set commentstring=//\ %s
autocmd FileType scheme set commentstring=;\ %s
autocmd FileType scala set commentstring=//\ %s
autocmd FileType php set commentstring=//\ %s
autocmd FileType arduino set commentstring=//\ %s

""" Some lang specific things
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
autocmd BufRead,BufNewFile *.sld setlocal filetype=sild
    autocmd FileType sild set syntax=scheme
autocmd BufRead,BufNewFile *.ino setlocal filetype=arduino
autocmd BufRead,BufNewFile *.scala setlocal filetype=scala

autocmd FileType scheme setlocal shiftwidth=2
autocmd FileType scheme setlocal tabstop=2
autocmd FileType scheme setlocal softtabstop=2

function! StripTrailing()
    let previous_search=@/
    let previous_cursor_line=line('.')
    let previous_cursor_column=col('.')
    %s/\s\+$//e
    let @/=previous_search
    call cursor(previous_cursor_line, previous_cursor_column)
endfunction
nmap <leader><space> :call StripTrailing()<CR>

let &t_EI .= "\e[1 q"
let &t_SI .= "\e[5 q"

" make 'gf' more aware
" set includeexpr=substitute(v:fname,'_','/','g').'.php'
" set path =
            " \~/path1
            " \~/path2

" set suffixesadd=.tpl,.php,.js,.scss

function! LineNumberToggle()
    if &number
        set nonumber
    else
        set number
    endif
endfunc
nnoremap gn :call LineNumberToggle()<CR>

colorscheme solarized
set background=dark

" open/close quickfix easily
nnoremap <LEADER>c :cclose<cr>
nnoremap <LEADER>o :copen<cr>

" hey look λ lol
imap <C-l> <C-k>*l

" nnoremap <silent> go :!Git next<CR>
" nnoremap <silent> gi :!Git prev<CR>

" see you next time!
autocmd VimLeave * :mksession! ~/.vim/sessions/last.vim


" plugins; for new install don't forget to install plug.vim first:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'scrooloose/nerdtree'
    Plug 'altercation/vim-colors-solarized'
    Plug 'mattn/webapi-vim'
    Plug 'jfo/vim-runners'
    Plug 'jfo/hound.vim'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'do': './install --bin' }
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'sheerun/vim-polyglot'
call plug#end()

" Stupid uninvited key mapping
let g:ftplugin_sql_omni_key = 'stfu'
