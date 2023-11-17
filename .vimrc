""XX  set nocompatible

"----------------------------------------------------------------------
" Basic Options
"----------------------------------------------------------------------
""XX  let mapleader=";"         " The <leader> key
set encoding=utf-8
set autoread              " Reload files that have not been modified
set backspace=2           " Makes backspace not behave all retarded-like
set colorcolumn=80        " Highlight 80 character limit
set cursorline            " Highlight the line the cursor is on
set hidden                " Allow buffers to be backgrounded without being saved
set laststatus=2          " Always show the status bar
set list                  " Show invisible characters
set listchars=tab:›\ ,eol:¬,trail:⋅ "Set the characters for the invisibles
set relativenumber        " Show relative line numbers
set ruler                 " Show the line number and column in the status bar
set t_Co=256              " Use 256 colors
set scrolloff=999         " Keep the cursor centered in the screen
set showbreak=↪           " The character to put to show a line has been wrapped
set showmatch             " Highlight matching braces
set showmode              " Show the current mode on the open buffer
set splitbelow            " Splits show up below by default
set splitright            " Splits go to the right by default
set visualbell            " Use a visual bell to notify us

""XX  syntax on                 " Enable filetype detection by syntax

" Force use of hjkl instead of arrows! Learn them!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Search settings
set hlsearch   " Highlight results
set ignorecase " Ignore casing of searches
set incsearch  " Start showing results as you type
set smartcase  " Be smart about case sensitivity when searching

" Tab settings
set expandtab     " Expand tabs to the proper type and size
set tabstop=2     " Tabs width in spaces
set softtabstop=2 " Soft tab width in spaces
set shiftwidth=2  " Amount of spaces when shifting

" Tab completion settings
set wildmode=list:longest     " Wildcard matches show a list, matching the longest first
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.6           " Ignore Go compiled files
set wildignore+=*.pyc         " Ignore Python compiled files
set wildignore+=*.rbc         " Ignore Rubinius compiled files
set wildignore+=*.swp         " Ignore vim backups

" GUI settings
if has("gui_running")
    set guifont=Inconsolata\ for\ Powerline:h14
    set guioptions=egmt
    set fuopt+=maxhorz
endif

"----------------------------------------------------------------------
" Key Mappings
"----------------------------------------------------------------------
" Remap a key sequence in insert mode to kick me out to normal
" mode. This makes it so this key sequence can never be typed
" again in insert mode, so it has to be unique.
inoremap jj <esc>
inoremap jJ <esc>
inoremap Jj <esc>
inoremap JJ <esc>
inoremap jk <esc>
inoremap jK <esc>
inoremap Jk <esc>
inoremap JK <esc>

" Make j/k visual down and up instead of whole lines. This makes word
" wrapping a lot more pleasent.
map j gj
map k gk

" cd to the directory containing the file in the buffer. Both the local
" and global flavors.
nmap <leader>cd :cd %:h<CR>
nmap <leader>lcd :lcd %:h<CR>

" Shortcut to edit the vimrc
nmap <silent> <leader>vimrc :e ~/.vimrc<CR>

" Make navigating around splits easier
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" Shortcut to yanking to the system clipboard
map <leader>y "*y
map <leader>p "*p

" Cancel search highlights
noremap <silent><leader><space> :nohlsearch<cr>

" Command to write as root if we dont' have permission
cmap w!! %!sudo tee > /dev/null %

" Expand in command mode to the path of the currently open file
cnoremap %% <C-R>=expand('%:h').'/'<CR>

"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
""XX  " Clear whitespace at the end of lines automatically
""XX  autocmd BufWritePre * :%s/\s\+$//e
""XX  
""XX  " Don't fold anything.
""XX  autocmd BufWinEnter * set foldlevel=999999
""XX  
""XX  " Reload Powerline when we read a Puppet file. This works around
""XX  " some weird bogus bug.
""XX  autocmd BufNewFile,BufRead *.pp call Pl#Load()

"----------------------------------------------------------------------
" Plugin settings
"----------------------------------------------------------------------
""XX  " CtrlP
""XX  let g:ctrlp_max_files = 10000
""XX  if has("unix")
""XX      let g:ctrlp_user_command = {
""XX          \ 'types': {
""XX              \ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
""XX              \ 2: ['.hg', 'hg --cwd %s locate -I .'],
""XX          \ },
""XX          \ 'fallback': 'find %s -type f | head -' . g:ctrlp_max_files
""XX      \ }
""XX  endif
""XX  
""XX  " EasyMotion
""XX  let g:EasyMotion_leader_key = '<leader><leader>'
""XX  
""XX  " Powerline
""XX  let g:Powerline_symbols="fancy" " Fancy styling
""XX  
""XX  " Syntastic
""XX  let g:syntastic_python_checker="pyflakes"
""XX  let g:syntastic_mode_map = { 'mode': 'active',
""XX                             \ 'active_filetypes': [],
""XX                             \ 'passive_filetypes': ['cpp', 'go', 'puppet'] }
""XX  
""XX  

"----------------------------------------------------------------------
" Backup settings
"----------------------------------------------------------------------
" http://stackoverflow.com/a/9528322
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/

""XX  " http://stackoverflow.com/a/6702397
""XX  " Prevent backups from overwriting each other. The naming is weird,
""XX  " since I'm using the 'backupext' variable to append the path.
""XX  " So the file '/home/docwhat/.vimrc' becomes '.vimrc%home%docwhat~'
""XX  au BufWritePre * let &backupext ='@'.substitute(substitute(substitute(expand('%:p:h'), '/', '%', 'g'), '\', '%', 'g'),  ':', '', 'g').'~'

set backup
set writebackup

"----------------------------------------------------------------------
" Swap settings
"----------------------------------------------------------------------
" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

"----------------------------------------------------------------------
" Save session
"----------------------------------------------------------------------
""XX  " Tell vim to remember certain things when we exit
""XX  "  '10  :  marks will be remembered for up to 10 previously edited files
""XX  "  "100 :  will save up to 100 lines for each register
""XX  "  :20  :  up to 20 lines of command-line history will be remembered
""XX  "  %    :  saves and restores the buffer list
""XX  "  n... :  where to save the viminfo files
""XX  set viminfo='10,\"100,:20,%,n~/.vim/viminfo
""XX  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif


