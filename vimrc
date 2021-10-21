" .vimrc with airline, vimwiki, and undofile
" M K Gharzai <kabeer@gharzai.net>
" Tue 18 Jun 2019 11:46:38 AM EDT

scriptencoding utf-8
set encoding=utf-8
set smartcase
set incsearch
set number
set ignorecase
set ruler
set ls=2
set tabstop=4
set autoindent
set copyindent
set listchars=eol:$,tab:»·,trail:·
"olorscheme ir_black
colorscheme one " https://github./rark/vim-one.git
set background=dark  " for the dark version
" t background=light " for the lite version
syntax on
set noexpandtab
" set formatoptions=croqlt

set tw=120

set mouse=a

if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif
set undodir=~/.vim/undo
set undofile

" vimwiki
set nocompatible
filetype plugin on

" 12.1 Registered Wiki
" vimwiki-option-syntax : default , markdown , media
" only default -> wiki2html
let g:vimwiki_list = 
\[{
\ 'syntax'          : 'default',
\ 'path'            : '~/work/wiki/',
\ 'path_html'       : '~/work/wiki/html/',
\ 'template_path'   : '~/work/wiki/templates/',
\ 'template_default': 'template',
\ 'template_ext'    : '.html',
\}]

let g:airline_theme='serene'
" default is dark_minimal
" badcat badwolf behelit kolor murmur onedark powerlineish raven serene simple vice
" minimalist peaksea ubaryd wombat
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
