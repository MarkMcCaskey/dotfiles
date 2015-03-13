set nocompatible
" filetype off

execute pathogen#infect()
filetype plugin indent on

set shell=/bin/bash

set backspace=2

" set rtp+=~/.vim/bundle/vundle
" call vundle#rc()

" Bundle 'gmarik/vundle'
" Bundle 'Valloric/YouCompleteMe'

filetype plugin indent on

set number
set rnu

" Tab specific option
" set tabstop=8                   "A tab is 8 spaces
" set expandtab                   "Always uses spaces instead of tabs
" set softtabstop=4               "Insert 4 spaces when tab is pressed
" set shiftwidth=4                "An indent is 4 spaces
set shiftround                  " Round indent to nearest shiftwidth multiple

"set solarized_termcolors=256

syntax enable
set background=dark

nmap <space> viw

filetype plugin on

nnoremap - ddp
nnoremap _ ddkP
inoremap <c-d> <esc>ddi
inoremap <c-u> <esc>viwUvi
nnoremap <c-u> viwUv
