# Sourcegraph vim plugin

**WORK IN PROGRESS**

## Installation

To use this plugin, you must first install [srclib](https://srclib.org).

Your Vim must be complied with `+byte_offset`, to check if your version of Vim has this, run `vim --version | grep +byte_offset`

It is recommended to install this with [pathogen](https://github.com/tpope/vim-pathogen).
Once pathogen is installed run:
```
cd ~/.vim/bundle
git clone https://github.com/MarkMcCaskey/sourcegraph-vim.git
```
**NOTE**

If your default shell is Fish add `set shell=/bin/bash` or `set shell=/bin/sh` to your `.vimrc`.  Vim will throw an error when trying to run certain commands through fish.

## Keybindings

By default, the keybindings are:
```
,aa - Sourcegraph_jump_to_definition(0)
,oo - Sourcegraph_describe(0)
,ee - Sourcegraph_usages(0)
,uu - Sourcegraph_search_site()
,ah - Sourcegraph_jump_to_definition(1)
,oh - Sourcegraph_describe(1)
,eh - Sourcegraph_usages(1)
,al - Sourcegraph_jump_to_definition(2)
,ol - Sourcegraph_describe(2)
,el - Sourcegraph_usages(2)
,aj - Sourcegraph_jump_to_definition(3)
,oj - Sourcegraph_describe(3)
,ej - Sourcegraph_usages(3)
,ak - Sourcegraph_jump_to_definition(4)
,ok - Sourcegraph_describe(4)
,ek - Sourcegraph_usages(4)

```
(note, these are the keybindings used during development of sourcegraph-vim and may not be convenient on keylayouts other than Dvorak -- they will be changed once the program is closer to being fully functional)


You can prevent these defaults from being loaded by adding `let g:sg_default_keybindings = 0` to your `.vimrc`.

You can define new keybindings by adding:
```
:noremap <keys> :call Sourcegraph_jump_to_definition(0)<cr>
:noremap <keys> :call Sourcegraph_describe(0)<cr>
:noremap <keys> :call Sourcegraph_usages(0)<cr>
:noremap <keys> :call Sourcegraph_search_site()<cr>
```
To make direction specific buffer opening, call the above functions with one of the following values:
```
0 - use default buffer opening locations
1 - open to the left
2 - open to the right
3 - open below
4 - open above
```
to your `.vimrc`.
The control key is `<c-x>` and the alt key is `<a-x>` or `<m-x>` where x is any key.
Due to the way Vim handles keybindings by level of specificity, trying to map these over existing keybindings may cause problems.
(note: add more detail here later)

## Help

To read the documentation type `:help SG-Vim`.
The general style of the tags is to capitalize the first letter of all words and prefix all Sourcegraph-Vim specific help documentation with `SG-Vim` or `Sourcegraph-Vim`.
For example:
```
:help SG-VimUsages
:help Sourcegraph-VimLicense
:help SG-VimContents
```
