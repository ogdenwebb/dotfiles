" FileType:
autocmd FileType vim setlocal shiftwidth=2
autocmd FileType haskell setlocal shiftwidth=2


" C Settings:
" au FileType c set makeprg=gcc\ %
au FileType c set makeprg=clang\ %
au FileType cpp set makeprg=clang++\ %

" OCaml:
autocmd FileType ocaml setlocal shiftwidth=2

" HTML:
autocmd FileType html setlocal shiftwidth=2
let g:html_indent_inctags = "html,body,head,tbody"

" if has("autocmd")
"     au BufReadPost *.rkt,*.rktl set filetype=racket
"     au filetype racket set lisp
"     au filetype racket set autoindent
" endif

" }}}
