" Extracted from multiple dusty files over the course of eons
" and brought together in the fires of mordor
"
" We ain't got no time for vi
set nocompatible
filetype off

set rtp+=~/.fzf
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle "gmarik/Vundle.vim"
Bundle "tpope/vim-dispatch"
Bundle "tpope/vim-commentary"
Bundle "tpope/vim-fugitive"
Bundle "kchmck/vim-coffee-script"
Bundle "rking/ag.vim"
Bundle "fatih/vim-go"
Bundle "rizzatti/dash.vim"
Bundle "altercation/vim-colors-solarized"
Bundle "derekwyatt/vim-scala"

call vundle#end()
filetype plugin indent on
syntax on

" Uncategorized config
set number                      " Show line numbers
set numberwidth=5
set laststatus=2
set history=10000
set backspace=indent,eol,start
set noeol
set hidden                      " Buffers do not need to be in a viewport
set backspace=2
let mapleader=","
set pastetoggle=§               " Set paste on and off with special key
set autoread                    " When file changes -> auto reload buffer
set list listchars=tab:»·,trail:·
set nofoldenable
set ruler
set cursorline
set showmatch
set showcmd
set switchbuf=useopen
set title

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
set wildmode=list:longest

" Fix slow O inserts
set timeout timeoutlen=1000 ttimeoutlen=100
set ttyfast
set shell=/usr/local/bin/zsh

" Pimp it!
colorscheme base16-default
set background=dark

" Use The Silver Searcher instead of grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --column
endif

if has("gui_running")
    "macvim stuff
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    set guifont=Monaco:h14
    set lines=80 columns=100

    " Switch to tabs
    noremap <D-1> :tabn 1<CR>
    noremap <D-2> :tabn 2<CR>
    noremap <D-3> :tabn 3<CR>
    noremap <D-4> :tabn 4<CR>
    noremap <D-5> :tabn 5<CR>
    noremap <D-6> :tabn 6<CR>
    noremap <D-7> :tabn 7<CR>
    noremap <D-8> :tabn 8<CR>
    noremap <D-9> :tabn 9<CR>
    " Command-0 goes to the last tab
    noremap <D-0> :tablast<CR>
endif

" Jumps to the last known position in a file after opening it except
" git commit messages
autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" you need to learn the(by) force
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Cycle through args
nnoremap <leader>n :next<cr>
nnoremap <leader>p :previous<cr>

" Move splits with motion keys
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

" Run specs on current file with zeus and dispatch
nnoremap <leader>ds :Dispatch bundle exec rspec --format progress %<cr>

" Run spec on current file
nnoremap <leader>sa :!bundle exec rspec -I. -b --no-color %<cr>

" Run test under zeus
nnoremap <leader>zs :!zeus test --no-color --format progress %<cr>

" Don't think twice when in need of some vimness
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

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
vnoremap <leader>gv :<c-u>call GrepIn(visualmode())<cr>
nnoremap <leader>g :silent exe "Ag! " . shellescape(expand("<cWORD>")) . "."<cr>:copen<cr>

" Automatically spell check certain file types
autocmd FileType gitcommit setlocal spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Resize splits automatically when the window is resized
au VimResized * exe "normal! \<c-w>="

" Tab complete when not in begining or end of line
" Extracted and modified from: http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
function! CleverTab()
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-N>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

nnoremap <silent> <Leader><Leader> :FZF -m<CR>
nnoremap <silent> <Leader>s :call fzf#run({ 'tmux_height': winheight('.') / 2, 'sink': 'botright split' })<CR>
nnoremap <silent> <Leader>v :call fzf#run({ 'tmux_width': winwidth('.') / 2, 'sink': 'vertical botright split' })<CR>

function! GitCommand(command)
  let result = system(a:command)
  if empty(result)
    echom "No files to edit."
    return
  endif
  let files  = join(split(result, "\n"), " ")
  exe "args " . expand(files)
endfunction

" Open git unstaged files, great to resume work
command! GitModified  :call GitCommand("git status --porcelain | sed -ne 's/^ M//p'")
" Open git conflict files to scroll through in buffer list
command! GitConflict  :call GitCommand("git diff --name-only --diff-filter=U")

" Correctly ident a JSON file
command! FormatJSON %!python -m json.tool
