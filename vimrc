" don't bother with vi compatibility

set nocompatible

" enable syntax highlighting
syntax enable

" configure Vundle
"
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off

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

" set autoindent
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
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" keyboard shortcuts

let mapleader = '\'
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" map h gh
" map j gj
" map k gk
" map l gl

" nnoremap <leader>a :Hound<space><C-R>"<CR>
nnoremap <leader>a :Hound<space>
vnoremap <leader>a y:Hound<space><C-R>"<CR>

nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>t :CtrlP<CR>
nmap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nmap <leader>q :GitGutterToggle<CR>
nmap <leader>c <Plug>Kwbd
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

" in case you forgot to sudo
cmap w!! %!sudo tee > /dev/null %

" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown

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

" keyboard shortcuts
inoremap jj <ESC>

" highlight search

set hlsearch
nmap <leader>hl :let @/ = ""<CR>

" gui settings
" if (&t_Co == 256 || has('gui_running'))
"   if ($TERM_PROGRAM == 'iTerm.app')
"     colorscheme solarized
"   else
"     colorscheme desert
"   endif
" endif


" set colorcolumn=81

set foldmethod=indent
set foldnestmax=2
set foldlevelstart=20

nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

set smartindent
set autoindent

highlight LineNr ctermfg=blue

autocmd FileType clojure set commentstring=;\ %s
autocmd FileType asm set commentstring=//\ %s
autocmd FileType vm set commentstring=//\ %s

autocmd FileType scheme set commentstring=;\ %s
autocmd FileType scheme setlocal shiftwidth=2
autocmd FileType scheme setlocal tabstop=2
autocmd FileType scheme setlocal softtabstop=2

nnoremap <LEADER>w :w<CR>

" experimental runners section!

if @% == '*_spec.rb'
  autocmd FileType ruby command! Run w % | !rspec %
endif

nnoremap <LEADER>g :call Runners()<CR>:Run<CR>

" more natural splits by default
set splitbelow
set splitright
let $MYVIMRC = '/users/jeff/.vimrc'

let g:gist_clip_command = 'pbcopy'

" in order to ensure that vim is congruent with zsh:
set shell=/bin/sh

map <SPACE> :Eval<CR>

" set background=light
" set background=dark
" call togglebg#map("<F5>")

let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['ruby', 'php'],
                           \ 'passive_filetypes': ['php'] }


" delete buffers in cntrl-p buffer mode with 'cntrl-@'
let g:ctrlp_buffer_func = { 'enter': 'MyCtrlPMappings' }

func! MyCtrlPMappings()
    nnoremap <buffer> <silent> <c-@> :call <sid>DeleteBuffer()<cr>
endfunc

func! s:DeleteBuffer()
    let line = getline('.')
    let bufid = line =~ '\[\d\+\*No Name\]$' ? str2nr(matchstr(line, '\d\+'))
        \ : fnamemodify(line[2:], ':p')
    exec "bd" bufid
    exec "norm \<F5>"
endfunc

" make 'gf' Etsyweb aware
set includeexpr=substitute(v:fname,'_','/','g').'.php'
set path=./*,~/development/Etsyweb/,~/development/Etsyweb/phplib/EtsyModel,~/development/Etsyweb/phplib,~/development/Etsyweb/templates,~/development/Etsyweb/htdocs,~/development/Etsyweb/phplib/Api,~/development/Etsyweb/phplib/Api/Resource,~/development/Etsyweb/htdocs/assets/js,~/development/Etsyweb/htdocs/assets/css
set suffixesadd=.tpl,.php,.js,.scss

" don't search from top if you hit the bottom:
set nowrapscan

au BufNewFile,BufRead *.scala setlocal ft=scala

autocmd FileType scala set commentstring=//\ %s
autocmd FileType php set commentstring=//\ %s

" Stupid uninvited key mapping
let g:ftplugin_sql_omni_key = 'stfu'

function! LineNumberToggle()
    if &number
        set nonumber
    else
        set number
    endif
endfunc

nnoremap gn :call LineNumberToggle()<CR>

" lets do some paredit! Or not. Fuck that thing.
" let g:paredit_electric_return = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

au BufRead,BufNewFile *.ino        set filetype=arduino
autocmd FileType arduino set commentstring=//\ %s

autocmd VimLeave * :mksession! ~/.vim/sessions/last.vim

let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["ruby"],
    \ "passive_filetypes": ["puppet"] }

let g:hound_base_url = "hound.etsycorp.com"
let g:hound_repos = "etsyweb,bigdata"
autocmd FileType houndresults nnoremap <CR> <C-w>gF

" if (g:colors_name =~ "solarized")
"     "let g:solarized_termcolors=256
"     autocmd ColorScheme * hi Normal ctermbg=015
"     autocmd ColorScheme * hi LineNr ctermfg=253 ctermbg=none cterm=none
"     autocmd ColorScheme * hi CursorLine ctermbg=255 cterm=none
"     autocmd ColorScheme * hi CursorColumn ctermbg=255 cterm=none
"     autocmd ColorScheme * hi StatusLine ctermfg=254 ctermbg=237
"     autocmd ColorScheme * hi StatusLineNC ctermfg=254 ctermbg=248
"     autocmd ColorScheme * hi VertSplit ctermfg=254 ctermbg=254 cterm=none
"     autocmd ColorScheme * hi Search ctermbg=230 cterm=none
"     autocmd ColorScheme * hi Comment ctermfg=248 ctermbg=231 cterm=none
"     if has("gui")
"         autocmd ColorScheme * hi Normal guibg=#ffffff
"         autocmd ColorScheme * hi LineNr guifg=#E0E0E0 guibg=none gui=none
"         autocmd ColorScheme * hi CursorLine guibg=#F1F1F1 gui=none
"         autocmd ColorScheme * hi CursorColumn guibg=#F1F1F1 gui=none
"         autocmd ColorScheme * hi StatusLine guifg=#E9E9E9 guibg=#4A4A4A
"         autocmd ColorScheme * hi StatusLineNC guifg=#E9E9E9 guibg=#B6B6B6
"         autocmd ColorScheme * hi VertSplit guifg=#E9E9E9 guibg=#E9E9E9 gui=none
"         autocmd ColorScheme * hi Search guibg=#FEFDDE gui=none
"         autocmd ColorScheme * hi Comment guifg=#B6B6B6 guibg=231 gui=none
"     endif
" endif


" set background=light
set background=light
call togglebg#map("<F5>")

" gui settings
if (&t_Co == 256 || has('gui_running'))
  if ($TERM_PROGRAM == 'iTerm.app')
    colorscheme solarized
  else
    colorscheme desert
  endif
endif

colorscheme solarized
