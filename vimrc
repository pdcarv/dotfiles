" Extracted from multiple dusty files over the course of eons
" and brought together in the fires of mordor
"
" We ain't got no time for vi
set nocompatible

execute pathogen#infect()
syntax on
filetype plugin indent on

" Uncategorized config
set number                      " Show line numbers
set numberwidth=5
set laststatus=2
set history=1000
set backspace=indent,eol,start
set hidden                      " Buffers do not need to be in a viewport
set backspace=2
let mapleader=","
set pastetoggle=§               " Set paste on and off with special key
set autoread                    " When file changes -> auto reload buffer
set list listchars=tab:»·,trail:·

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
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

filetype plugin indent on

" Status line
set cmdheight=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Give us autocomplete
set wildmenu
set wildignore+=.git,.svn 
set wildignore+=.DS_Store
set wildignore+=*/tmp/*
set wildignore+=*.so,*.swp
set wildignore+=*.zip,*.rar
set wildignore+=*.png,*.jpg

" Complete to longest string, like zsh
set wildmode=longest,list
set complete=.,w,t

" Fix slow O inserts
set timeout timeoutlen=1000 ttimeoutlen=100

" Pimp it!
colorscheme base16-mocha
set background=dark

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

if has("gui_running")
    "macvim stuff
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    set guifont=Menlo:h14
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

" Move splits with motion keys
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Toggle spell checking
noremap <Leader>sc :set spell!<cr>

" Run specs on current file with zeus
nnoremap <leader>zs :!zeus test --format progress % %<cr>

" Run spec on current file
nnoremap <leader>s :!bundle exec rake -I. test TEST="%" %<cr>

" Run rspec
nnoremap <leader>rs :!bundle exec rspec % %<cr>

" Search for word under the cursor and open in quickfix window
nnoremap <Leader>ag :grep! "\b<c-r><c-w>\b"<cr>:cw<cr>

" Name a tmux window after the open buffer's name
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

" Automatically spell check certain file types
autocmd FileType gitcommit setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Tab complete when not in begining or end of line
" Extracted and modified from: http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

