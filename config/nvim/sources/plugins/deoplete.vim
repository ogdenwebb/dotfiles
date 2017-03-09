" autocmd MyAutoCmd CompleteDone * pclose!
let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_smart_case = 1
" let g:deoplete#disable_auto_complete = 1

" Tab completion:
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Navigation via C-j and C-k:
imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

" Undo completion:
inoremap <expr><C-g> deoplete#undo_completion()

" <CR>: close popup and save indent:
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

" Omni Complete:
" let g:deoplete#omni#input_patterns.ocaml = '[^. *\t]\.\w*'
" let g:deoplete#omni_patterns.ocaml = '[^. *\t]\.\w*'
if !exists('g:deoplete#omni_patterns')
  let g:deoplete#omni_patterns = {}
endif

let g:deoplete#omni_patterns.ocaml = '[^. *\t]\%(\.\|_\)\w*\|\h\w*|#'
