set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" trying out something new because .swx files are annoying me in munki repo
" http://stackoverflow.com/questions/821902/disabling-swap-files-creation-in-vim
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

set autochdir
set backspace=indent,eol,start
set encoding=utf-8
set hls ic is
set listchars=tab:▸\ ,eol:¬,trail:~
set scrolloff=3
set showcmd
set showmatch
set sts=4 sw=4 ts=4 expandtab
set title titleold=""
set visualbell
set wildmenu
set wildmode=list:longest
set wrapscan

let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

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

nnoremap <silent> <C-l> :noh<CR><C-l>

syntax on
set background=dark
colorscheme solarized

if has('gui_running')
  set lines=40 columns=90
  set guifont=Source_Code_Pro:h14
endif

if has("autocmd")
    autocmd BufNew,BufNewFile,BufRead *.json set filetype=json
    autocmd BufNew,BufNewFile,BufRead *.mk set filetype=xml
    autocmd BufNew,BufNewFile,BufRead *.mobileconfig set filetype=xml
    autocmd BufNew,BufNewFile,BufRead *.plist set filetype=xml
    autocmd BufNew,BufNewFile,BufRead *.recipe set filetype=xml
    autocmd BufNew,BufNewFile,BufRead Makefile set filetype=make
    
    "Syntax of these languages is fussy over tabs vs. spaces
    autocmd FileType make setlocal ts=8 sts=0 sw=8 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=0 sw=2 expandtab

    " personal preferences
    autocmd FileType py setlocal colorcolumn=80
    autocmd FileType python setlocal colorcolumn=80
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType xml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType xhtml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType awk setlocal ts=2 sts=2 sw=2 expandtab

    " remove auto-commenting for all filetypes
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
endif
