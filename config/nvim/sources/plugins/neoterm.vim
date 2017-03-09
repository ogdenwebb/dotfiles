let g:neoterm_position = 'horizontal'
" let g:neoterm_automap_keys = '<leader>tt'

nnoremap <silent> <leader>tp :TREPLSendFile<cr>
nnoremap <silent> <leader>tr :TREPLSend<cr>
vnoremap <silent> <leader>tr :TREPLSend<cr>

" run set test lib
" nnoremap <silent> ,rt :call neoterm#test#run('all')<cr>
" nnoremap <silent> ,rf :call neoterm#test#run('file')<cr>
" nnoremap <silent> ,rn :call neoterm#test#run('current')<cr>
" nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>

" hide/close terminal
nnoremap <silent> <leader>to :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> <leader>tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> <leader>tc :call neoterm#kill()<cr>
