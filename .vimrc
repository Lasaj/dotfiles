set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" My plugins
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-bufferline'
Plugin 'neovimhaskell/haskell-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" line numbers
set number

" indenting
set tabstop=8
set shiftwidth=4
set softtabstop=4
set autoindent
set expandtab

set mouse=a
set ruler
set cursorline
set backspace=indent,eol,start

syntax on

" case insensitive search
set ignorecase
set smartcase

" highlight column 80
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" setup for gruvbox
set t_Co=256
set background=dark
colorscheme gruvbox
highlight normal ctermbg = NONE
" let g:gruvbox_contrast_dark = 'soft'

" YouCompleteMe
set encoding=utf-8
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_global_ycm_extra_conf = '/home/rick/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

" bufferline
let g:bufferline_echo = 0

" split settings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" for tmux
set term=screen-256color

