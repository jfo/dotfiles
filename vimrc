" don't bother with vi compatibility

set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
" if new install don't forget to install vundle manually with probably:
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

    " let Vundle manage Vundle, required
    Plugin 'gmarik/Vundle.vim'

    " install Vundle bundles
    if filereadable(expand("~/.vimrc.bundles"))
      source ~/.vimrc.bundles
    endif

call vundle#end()

" ensure ftdetect et al work by including this after the Vundle stuff
filetype plugin indent on

set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab                                                " expand tabs to spaces
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set nonumber                                                 " don't show line numbers by default
set ruler                                                    " show where you are
set scrolloff=5                                              " show context above/below cursorline
set shiftwidth=4                                             " normal mode indentation commands use 4 spaces
set showcmd
set smartcase                                                " case-sensitive search if any caps
set softtabstop=4                                            " insert mode tab and backspace use 4 spaces
set tabstop=8                                                " actual tabs occupy 8 characters
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set nowrapscan                                               " don't search from top if you hit the bottom

set foldmethod=indent
set foldnestmax=2
set foldlevelstart=20

set wildignore=

let g:ctrlp_custom_ignore = {
            \ 'dir': 'bin\/*',
            \ }

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" keyboard shortcuts
let mapleader = '\'

nnoremap <leader>a :HoundQF<space>
vnoremap <leader>a y:HoundQF<space><C-R>"<CR>

nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

function! StripTrailing()
    let previous_search=@/
    let previous_cursor_line=line('.')
    let previous_cursor_column=col('.')
    %s/\s\+$//e
    let @/=previous_search
    call cursor(previous_cursor_line, previous_cursor_column)
endfunction
nmap <leader><space> :call StripTrailing()<CR>

" plugin settings
let g:NERDSpaceDelims=1

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown

" sld is sild
autocmd BufRead,BufNewFile *.sld set filetype=sild

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set hlsearch
nmap <leader>hl :let @/ = ""<CR>

" Holy shit FZF
nmap <C-P> :Files<CR>
nmap <leader>b :Buffers<CR>

set smartindent
set autoindent

highlight LineNr ctermfg=blue

" commentary.vim comment strings
autocmd FileType sild set commentstring=;\ %s
autocmd FileType clojure set commentstring=;\ %s
autocmd FileType asm set commentstring=//\ %s
autocmd FileType vm set commentstring=//\ %s

autocmd FileType scheme set commentstring=;\ %s
autocmd FileType scheme setlocal shiftwidth=2
autocmd FileType scheme setlocal tabstop=2
autocmd FileType scheme setlocal softtabstop=2

nnoremap <LEADER>w :w<CR>

" vim-runners!
nnoremap <LEADER>g :Run<CR>

" more natural splits by default
set splitbelow
set splitright

" make 'gf' Etsyweb aware
set includeexpr=substitute(v:fname,'_','/','g').'.php'
set path=./*,~/development/Etsyweb/,~/development/Etsyweb/phplib/EtsyModel,~/development/Etsyweb/phplib,~/development/Etsyweb/templates,~/development/Etsyweb/htdocs,~/development/Etsyweb/phplib/Api,~/development/Etsyweb/phplib/Api/Resource,~/development/Etsyweb/htdocs/assets/js,~/development/Etsyweb/htdocs/assets/css
set suffixesadd=.tpl,.php,.js,.scss


au BufNewFile,BufRead *.scala setlocal ft=scala

autocmd FileType scala set commentstring=//\ %s
autocmd FileType php set commentstring=//\ %s

function! LineNumberToggle()
    if &number
        set nonumber
    else
        set number
    endif
endfunc

nnoremap gn :call LineNumberToggle()<CR>

au BufRead,BufNewFile *.ino  set filetype=arduino
autocmd FileType arduino set commentstring=//\ %s

autocmd VimLeave * :mksession! ~/.vim/sessions/last.vim

let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["ruby"],
    \ "passive_filetypes": ["puppet"] }

let g:hound_base_url = "hound.etsycorp.com"
let g:hound_repos = "etsyweb,bigdata"
let g:hound_repo_paths = { "etsyweb": "~/development/Etsyweb", }

autocmd FileType houndresults nnoremap <CR> <C-w>gF

call togglebg#map("<F5>")

colorscheme solarized
set background=dark

" open/close quickfix easily
nnoremap <LEADER>c :cclose<cr>
nnoremap <LEADER>o :copen<cr>

" hey look λ lol
imap <C-l> <C-k>*l
