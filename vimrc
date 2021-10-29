" .vimrc with airline, vimwiki, and undofile
" M K Gharzai <kabeer@gharzai.net>
" Tue 18 Jun 2019 11:46:38 AM EDT

scriptencoding utf-8
set autoindent
set copyindent
set encoding=utf-8
set hls
set ignorecase
set incsearch
set listchars=eol:$,tab:»·,trail:·
set ls=2
set number
set ruler
set smartcase
set tabstop=4
"olorscheme ir_black
colorscheme one " https://github./rark/vim-one.git
"et background=dark  " for the dark version
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
\ 'path'            : '~/Documents/wiki/',
\ 'path_html'       : '~/Documents/wiki/html/',
\ 'template_path'   : '~/Documents/wiki/templates/',
\ 'template_default': 'template',
\ 'template_ext'    : '.html',
\}]

let g:airline_theme='serene'
" default is dark_minimal
" badcat badwolf behelit kolor murmur onedark powerlineish raven serene simple vice
" minimalist peaksea ubaryd wombat
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

call plug#begin('~/.vim/plugged')
Plug 'vimwiki/vimwiki'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

" General colors
if has('gui_running') || has('nvim')
    hi Normal guifg=#f6f3e8 guibg=#242424
else
    " Set the terminal default background and foreground colors, thereby
    " improving performance by not needing to set these colors on empty cells.
    hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
    let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
    let &t_te = &t_te . "\033]110\007\033]111\007"
endif

" vim hardcodes background color erase even if the terminfo file does
" not contain bce (not to mention that libvte based terminals
" incorrectly contain bce in their terminfo files). This causes
" incorrect background rendering when using a color theme with a
" background color.
let &t_ut=''

" for transparent background
function! AdaptColorscheme()
   highlight clear CursorLine
   highlight Normal ctermbg=none
   highlight LineNr ctermbg=none
   highlight Folded ctermbg=none
   highlight NonText ctermbg=none
   highlight SpecialKey ctermbg=none
   highlight VertSplit ctermbg=none
   highlight SignColumn ctermbg=none
endfunction
autocmd ColorScheme * call AdaptColorscheme()

highlight Normal guibg=NONE ctermbg=NONE
highlight CursorColumn cterm=NONE ctermbg=NONE ctermfg=NONE
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE
highlight CursorLineNr cterm=NONE ctermbg=NONE ctermfg=NONE
highlight clear LineNr
highlight clear SignColumn
highlight clear StatusLine


" Change Color when entering Insert Mode
"autocmd InsertEnter * set nocursorline

" Revert Color to default when leaving Insert Mode
"autocmd InsertLeave * set nocursorline

"" extra settings, uncomment them if necessary :)
"set cursorline
"set noshowmode
"set nocursorline

" trasparent end
