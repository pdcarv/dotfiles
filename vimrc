" Extracted from multiple dusty files over the course of eons
" and brought together in the fires of mordor

" We ain't got no time for vi
set nocompatible

call pathogen#infect()

" Uncategorized config
set number                      " Show line numbers
set laststatus=2                
set history=1000
set backspace=indent,eol,start
set hidden                      " Buffers do not need to be in a viewport
set backspace=2
let mapleader=","
set pastetoggle=§               " Set paste on and off with special key

" Searches
set incsearch
set hlsearch
noremap <CR> :nohlsearch<cr>    

" No swap
set noswapfile
set nobackup

" Indenting options
set autoindent
set smartindent
set smarttab
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

filetype plugin indent on

" Status line
set cmdheight=2
set showtabline=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Give us autocomplete 
set wildmenu
set wildignore+=.git,.svn 
set wildignore+=.DS_Store
set wildignore+=*.png,*.jpg
set wildignore+=log/**
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildmode=longest,list       " Complete to longest string, like zsh

" Colors and visual options
syntax enable
set t_Co=256
set background=light
color github 

if has("gui_running")
    "macvim stuff
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    set guifont=Menlo:h12
    set lines=80 columns=100
endif

" Jumps to the last known position in a file after opening it except
" git commit messages
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" I need to be forced not tu use the arrow keys, this disables them
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Ack.vim search for current line with <leader>a
noremap <Leader>a :Ack! <cword><cr>
ca Ack Ack!

" CtrlP options
let g:ctrlp_by_filename=1
let g:ctrlp_by_extensions=['tag'] 

" Ctags
map <F8> :!/usr/local/bin/ctags .<cr>
nnoremap <c-o> :CtrlPTag<cr>

" Run spec on current file with zeus
nnoremap <leader>zs :!zeus test --format progress % %<cr>


