set nocompatible
let mapleader=' ' "use space for leader key
filetype off "required for Vundle
" Cursor behaviour
:autocmd InsertEnter,InsertLeave * set cul!
" General visual look of Vim
set number relativenumber
set ruler
set noerrorbells
set visualbell
set laststatus=2
set showmode
set splitbelow splitright
" Text searching options
set incsearch
set ignorecase
set smartcase
set showmatch
" Syntax and formatting
syntax on
set encoding=utf-8
set formatoptions=tcqrn1
set hidden
" Tabs and indenting
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set scrolloff=3
" Command line completion options
set showcmd
set wildmenu
" Colors
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1

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
" nnoremap <Leader>t :split<Space>term://zsh<Space><bar><Space>resize<Space>10<CR>
vnoremap > >gv
vnoremap < <gv

" Plugins
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Vundle plugin to manage vundle, required
Plugin 'VundleVim/Vundle.vim'

" Add custom plugins here
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'morhetz/gruvbox'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()
filetype plugin indent on "required

" Call after plugin is loaded
colorscheme gruvbox
