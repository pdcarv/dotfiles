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
set history=10000
set backspace=indent,eol,start
set hidden                      " Buffers do not need to be in a viewport
set backspace=2
let mapleader=","
set pastetoggle=§               " Set paste on and off with special key
set autoread                    " When file changes -> auto reload buffer
set autowrite
set list listchars=tab:»·,trail:·
set nofoldenable
set ruler
set cursorline
set showmatch
set mouse=a
set switchbuf=useopen

" Searches
set hlsearch
noremap <cr> :nohlsearch<cr>

" No swap
set noswapfile
set nobackup

" Indenting options
set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

filetype plugin indent on

" Status line
set cmdheight=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Exuberant ctags
set tags=./tags,tags

" Give us autocomplete
set wildmenu
set wildignore+=.git,.svn
set wildignore+=.DS_Store
set wildignore+=*/tmp/*
set wildignore+=*.so,*.swp
set wildignore+=*.zip,*.rar
set wildignore+=*.png,*.jpg
set wildignore+=*.log
set wildignore+=*.o,*~,*.pyc

" Complete to longest string, like zsh
set wildmode=list:longest,full

" Fix slow O inserts
set timeout timeoutlen=1000 ttimeoutlen=100
set ttyfast

" Pimp it!
colorscheme base16-tomorrow
set background=light

" Use The Silver Searcher instead of grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
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

" Cycle through args
nnoremap <leader>n :next<cr>
nnoremap <leader>p :previous<cr>

" Move splits with motion keys
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

imap jk <Esc>

" Toggle spell checking
noremap <Leader>sc :set spell!<cr>

" Run specs on current file with zeus
nnoremap <leader>zs :!zeus test --format progress % %<cr>

" Run spec on current file
nnoremap <leader>s :!bundle exec rake -I. test TEST="%" %<cr>

" Run rspec
nnoremap <leader>rs :Dispatch bundle exec rspec --format progress %<cr>

" Search for word under the cursor
" Search for visual selection
" and open in quickfix window using Ag plugin
function! GrepIn(type)
    if a:type ==# 'v'
        normal! `<v`>y
    else
        return
    endif

    silent execute "Ag! " . shellescape(@@) . " ."
endfunction
vnoremap <leader>g :<c-u>call GrepIn(visualmode())<cr>

" Name a tmux window after the open buffer's name
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

" Automatically spell check certain file types
autocmd FileType gitcommit setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Resize splits automatically when the window is resized
au VimResized * exe "normal! \<c-w>="

" Tab complete when not in begining or end of line
" Extracted and modified from: http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
" Use omnicomplete if able for extra futureness
function! CleverTab()
  if pumvisible()
    return "\<C-N>"
  endif

  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-O>"
  else
    return "\<C-N>"
  endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

" limit command-t height to ten lines
let g:CommandTMaxHeight=10

noremap <F5> :CommandTFlush<cr>
