" Extracted from multiple dusty files over the course of eons
" and brought together in the fires of mordor

" We ain't got no time for vi
set nocompatible

call pathogen#infect()
syntax on
filetype plugin indent on

" Ctrlp ignore this
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Default ctrlp to filename search instead of path
let g:ctrlp_by_filename=1
let g:ctrlp_by_extensions=['tag'] 

" We want to see the current line
set cursorline

" Do not forces to save changes in bg buffers
set hidden

" Show line numbers
set number

" Always show the statusline
set laststatus=2

" Make backspace work like other apps
set backspace=2

" Indenting options
set autoindent
set smarttab

" No swap
set noswapfile

" Show matches as pattern is being typed
set incsearch
set hlsearch

" Always good convetion
set winwidth=79

" change leader
let mapleader=","

"status line
set cmdheight=2
set showtabline=2

set backspace=indent,eol,start

" Give us autocomplete files
set wildmenu
set wildignore+=.git,.svn 
set wildignore+=.DS_Store

" Complete to longest string, like zsh
set wildmode=longest,list

" Set paste on and off with special key
set pastetoggle=§

" Restrict search for tab completion sugestions
set complete=.,b,u,]

" Fix slow O inserts
set timeout timeoutlen=1000 ttimeoutlen=100

" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" default tabsettings
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Colors
set t_Co=256
set background=light
color pdc 

" change theme background color
call togglebg#map("<F5>")

set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Jumps to the last known position in a file after opening it except
" git commit messages
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

if has("gui_running")
	"macvim stuff
	set guioptions-=T
	set guioptions-=r
	set guioptions-=L
	set guifont=Menlo:h12
    set lines=80 columns=100
endif

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

" Clear highlights on return
noremap <CR> :nohlsearch<cr>

" Ack.vim search for current line with <leader>a
noremap <Leader>a :Ack! <cword><cr>
ca Ack Ack!

" Ctags
map <F8> :!/usr/local/bin/ctags .<cr>
nnoremap <c-o> :CtrlPTag<cr>

" run spec on current file with zeus
nnoremap <leader>zs :!zeus test --format progress % %<cr>



