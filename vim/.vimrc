set number relativenumber
set noerrorbells
set smartindent
syntax on
set incsearch
set splitbelow splitright
set ruler
set visualbell
set encoding=utf-8
set wrap
set textwidth=80
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set scrolloff=3
set hidden
set laststatus=2
set showmode
set showcmd
set ignorecase
set smartcase
set showmatch
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let mapleader=" "

" remappings
imap JJ <ESC>
inoremap ( ()<ESC>hli
inoremap { {}<ESC>hli
inoremap [ []<ESC>hli
inoremap ' ''<ESC>hli
inoremap " ""<ESC>hli
inoremap ` ``<ESC>hli
nnoremap ; :
nnoremap : ;
nnoremap <Leader>t :split<Space>term://zsh<Space><bar><Space>resize<Space>10<CR>


