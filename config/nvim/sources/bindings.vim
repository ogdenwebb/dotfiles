" Keybindings:
let mapleader="\<SPACE>"
let g:maplocalleader='\'

map Y y$

inoremap jk <Esc>

nnoremap ds das " because of vim-sandwich

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" }}}

" Terminal Bindings:
function! OpenTerm()
  20sp
  terminal
endfunction

nnoremap <Leader>t :call OpenTerm()<CR>

tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Spell Checking:
function! SpellCheck()
  if &spell == 0
    setlocal spell spelllang=ru
  else
    setlocal nospell
  endif
endfunction

nnoremap <F5> :call SpellCheck()<CR>

" }}}
