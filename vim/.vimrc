scriptencoding utf-8
set encoding=utf-8
set smartcase
set incsearch
set number
set ignorecase
set ruler
set ls=2
set tabstop=4
set background=dark
set autoindent
set copyindent
set listchars=eol:$,tab:»·,trail:·
colorscheme one
"olorscheme ir_black
syntax on
set noexpandtab
" set formatoptions=croqlt

set tw=120

set mouse=a

" vimwiki
set nocompatible
filetype plugin on

" 12.1 Registered Wiki
" vimwiki-option-syntax : default , markdown , media
" only default -> wiki2html
let g:vimwiki_list = [{'path': '~/work/wiki/', 'path_html': '~/work/wiki/html/', 'syntax': 'default'}]
