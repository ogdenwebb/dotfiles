" Functions:

" Convert Function:
function! Cp1251ToUtf8()
  e ++enc=cp1251
  set fileencoding=utf-8
  set fileformat=unix
endfunction

" Autoeload vimrc
augroup reload_vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" Resize splits when the window is resized
au VimResized * :wincmd =

" Autochange layout when enter/leave input mode
autocmd InsertLeave * silent !xkblayout-state -s 0

" }}}
