" .vimrc with airline, vimwiki, and undofile
" M K Gharzai <kabeer@gharzai.net>
" Tue 18 Jun 2019 11:46:38 AM EDT
" Wed Aug 10 00:46:10 2022

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
set softtabstop=4
set shiftwidth=4
"olorscheme ir_black
"olorscheme one " https://github./rark/vim-one.git
"et background=dark  " for the dark version
" t background=light " for the lite version
syntax on
set expandtab
" set formatoptions=croqlt
let mapleader=","

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
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"lug 'vimwiki/vimwiki'
Plug 'JuliaEditorSupport/julia-vim'
"lug 'davidhalter/jedi-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wadackel/vim-dogrun'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'zivyangll/git-blame.vim'
call plug#end()

"olorscheme dogrun
"olorscheme nord
colorscheme onedark

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

""""""""""""""""
" coc-specific
"
""""""""""""""""
"
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Git Blame
nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>
