set nocompatible
filetype off
filetype plugin indent on
autocmd! bufwritepost .vimrc source %
autocmd BufWritePre *.* :%s/\s\+$//e
set bs=2
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
syntax on
set nocompatible
set nocp
set nonumber
set tw=79
set nowrap
set fo-=t
set colorcolumn=80
set norelativenumber
"au FocusLost * :set number
"au FocusGained * :set relativenumber
set t_Co=256
color desert
highlight ColorColumn ctermbg=red
highlight LineNr ctermfg=235
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab
set hlsearch
set incsearch
set ignorecase
set smartcase
