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
filetype plugin indent on

set background=dark

if has('gui_running')
  set guifont=SourceCodePro:h14
endif

if has("autocmd")
    autocmd BufRead,BufNewFile *.json set filetype=json
    autocmd BufRead,BufNewFile *.mk set filetype=xml
    autocmd BufRead,BufNewFile *.recipe set filetype=xml
    autocmd BufRead,BufNewFile *.plist set filetype=xml
    
    "Syntax of these languages is fussy over tabs vs. spaces
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

    " personal preferences
    autocmd FileType py setlocal textwidth=80 colorcolumn=+1
    autocmd FileType sh setlocal textwidth=80 colorcolumn=+1
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType xml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType xhtml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType awk setlocal ts=2 sts=2 sw=2 expandtab

    " remove auto-commenting for all filetypes
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
endif
