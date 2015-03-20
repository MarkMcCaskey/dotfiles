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

" Sourcegraphvim Dvorak keybindings

let g:sg_default_keybings = 0
noremap <silent> ,a :call Sourcegraph_jump_to_definition()<cr>
noremap <silent> ,oo :call Sourcegraph_describe(0)<cr>
noremap <silent> ,ee :call Sourcegraph_usages(0)<cr>
noremap <silent> ,u :call Sourcegraph_search_site()<cr>
noremap <silent> ,oh :call Sourcegraph_describe(1)<cr>
noremap <silent> ,eh :call Sourcegraph_usages(1)<cr>
noremap <silent> ,ol :call Sourcegraph_describe(2)<cr>
noremap <silent> ,el :call Sourcegraph_usages(2)<cr>
noremap <silent> ,oj :call Sourcegraph_describe(3)<cr>
noremap <silent> ,ej :call Sourcegraph_usages(3)<cr>
noremap <silent> ,ok :call Sourcegraph_describe(4)<cr>
noremap <silent> ,ek :call Sourcegraph_usages(4)<cr>
noremap <silent> ,ii :call Sourcegraph_show_documentation(0)<cr>
noremap <silent> ,ih :call Sourcegraph_show_documentation(1)<cr>
noremap <silent> ,il :call Sourcegraph_show_documentation(2)<cr>
noremap <silent> ,ij :call Sourcegraph_show_documentation(3)<cr>
noremap <silent> ,ik :call Sourcegraph_show_documentation(4)<cr>

